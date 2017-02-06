# Copyright 2017 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Python AppEngine support for Bazel.

To create a Python WebApp for Google AppEngine, add the rules:
py_appengine_binary(
  name = "mywebapp",
  # data to put in the webapp, the directory structure of the data set
  # will be maintained.
  data = ["//mywebapp:data"],
  configs = ["//mywebapp:app.yaml"],
  srcs= ["main.py"],
)

#optional test
py_appengine_test(
  name = "mywebapp_test",
  srcs = ["main_test.py"],
  deps = [":main"],
  libraries = {"webapp2": "latest"},
)

To run locally:
bazel run :mywebapp

To deploy on Google app engine:
bazel run :mywebapp.deploy

Finally, the appengine macro also create a .deploy target that will try to use the
AppEngine SDK to upload your application to AppEngine. It takes an optional argument: the
APP_ID. If not specified, it uses the default APP_ID provided in the application
app.yaml.
"""


def _find_locally_or_download_impl(repository_ctx):
  if 'PY_APPENGINE_SDK_PATH' in repository_ctx.os.environ:
    path = repository_ctx.os.environ['PY_APPENGINE_SDK_PATH']
    if path == "":
      fail("PY_APPENGINE_SDK_PATH set, but empty")
    repository_ctx.symlink(path, ".")
  else:
    repository_ctx.download_and_extract(
        url="https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.50.zip",
        output=".",
        sha256="06e08edbfb64c52157582625010078deedcf08130f84a2c9a81193bbebdf6afa",
        stripPrefix="google_appengine")
  repository_ctx.template("BUILD", Label("//appengine:pysdk.BUILD"))


_find_locally_or_download = repository_rule(
    local = False,
    implementation = _find_locally_or_download_impl,
)


def py_appengine_repositories():
  _find_locally_or_download(name = "com_google_appengine_python")


def py_appengine_test(name, srcs, deps=[], data=[], libraries={}):
  """A variant of py_test that sets up an App Engine environment."""
  extra_deps = ["@com_google_appengine_python//:appengine"]
  for l in libraries:
    extra_deps.append("@com_google_appengine_python//:{0}-{1}".format(l, libraries[l]))
  native.py_test(
      name=name,
      deps=deps + extra_deps,
      srcs=srcs,
      data=data,
  )


def _py_appengine_binary_base_impl(ctx):
  """Implementation of the rule that creates
     - the script to run locally
     - the script to deploy
  """
  symlinks = dict()
  for c in ctx.attr.configs:
    files = c.files.to_list()
    for f in files:
      symlinks[f.basename] = f
  runfiles = ctx.runfiles(
      transitive_files=ctx.attr.binary.data_runfiles.files
      + ctx.attr.devappserver.data_runfiles.files
      + ctx.attr.appcfg.data_runfiles.files,
      symlinks=symlinks,
  )
  ctx.file_action(
      output=ctx.outputs.executable,
      content="""
#!/bin/bash
ROOT=$PWD
$ROOT/{0} app.yaml
""".format(ctx.attr.devappserver.files_to_run.executable.short_path),
      executable=True,
  )

  ctx.file_action(
      output=ctx.outputs.deploy_sh,
      content="""
#!/bin/bash
ROOT=$PWD
tmp_dir=$(mktemp -d ${{TMPDIR:-/tmp}}/war.XXXXXXXX)
cp -R $ROOT $tmp_dir
trap "{{ cd ${{root_path}}; rm -rf $tmp_dir; }}" EXIT
rm -Rf $tmp_dir/{1}/external/com_google_appengine_python
if [ -n "${{1-}}" ]; then
  $ROOT/{0} -A "$1" update $tmp_dir/{1}
  retCode=$?
else
  $ROOT/{0} update $tmp_dir/{1}
  retCode=$?
fi

rm -Rf $tmp_dir
trap - EXIT

exit $retCode
""".format(ctx.attr.appcfg.files_to_run.executable.short_path, ctx.workspace_name),
      executable=True,
  )

  return struct(runfiles=runfiles, py=ctx.attr.binary.py)


py_appengine_binary_base = rule(
    _py_appengine_binary_base_impl,
    attrs = {
        "binary": attr.label(),
        "devappserver": attr.label(default=Label("@com_google_appengine_python//:dev_appserver")),
        "appcfg": attr.label(default=Label("@com_google_appengine_python//:appcfg")),
        "configs": attr.label_list(allow_files=FileType([".yaml"])),
    },
    executable = True,
    outputs = {
        "deploy_sh": "%{name}_deploy.sh",
    },
)


def py_appengine_binary(name, srcs, configs, deps=[], data=[]):
  """Convenience macro that builds the app and offers an executable
     target to deploy on Google app engine.
  """
  native.py_library(
      name="_py_appengine_" + name,
      srcs = srcs,
      deps=deps,
  )
  py_appengine_binary_base(
      name=name,
      binary=":_py_appengine_" + name,
      configs=configs,
  )
  native.sh_binary(
      name = "%s.deploy" % name,
      srcs = ["%s_deploy.sh" % name],
      data = [name],
  )
