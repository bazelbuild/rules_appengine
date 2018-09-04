# Copyright 2018 The Bazel Authors. All rights reserved.
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
"""Language agnostic utility functions for use in the other .bzl files.

"""

load(
    ":variables.bzl",
    "APPENGINE_VERSION",
    "CLOUD_SDK_PLATFORM_ARCHIVE",
    "CLOUD_SDK_PLATFORM_SHA256",
    "SDK_URL_PREFIX",
)

def _find_locally_or_download_impl(repository_ctx):
    lang = repository_ctx.attr.lang
    env_var = lang.upper() + "_APPENGINE_SDK_PATH"
    if env_var in repository_ctx.os.environ:
        path = repository_ctx.os.environ[env_var]
        if path == "":
            fail(env_var + " set, but empty")
        repository_ctx.symlink(path, ".")
    else:
        substitutions = {
            "version": repository_ctx.attr.version,
        }
        repository_ctx.download_and_extract(
            url = "{}/{}".format(
                SDK_URL_PREFIX,
                repository_ctx.attr.filename_pattern.format(**substitutions),
            ),
            output = ".",
            sha256 = repository_ctx.attr.sha256,
            stripPrefix = repository_ctx.attr.strip_prefix_pattern.format(
                **substitutions
            ),
        )
    repository_ctx.template(
        "BUILD",
        Label("//appengine:{}/sdk.BUILD".format(lang.lower())),
    )

find_locally_or_download = repository_rule(
    attrs = {
        "lang": attr.string(
            mandatory = True,
            doc = "The language of the SDK to download.",
            values = ["java", "py"],
        ),
        "sha256": attr.string(
            mandatory = True,
            doc = "The sha256sum of the sdk zip file.",
        ),
        "version": attr.string(
            mandatory = True,
            doc = "The SDK version to download. Usually of the form %s." %
                  APPENGINE_VERSION,
        ),
        "strip_prefix_pattern": attr.string(
            default = "google_appengine",
            mandatory = True,
            doc =
                "When the zip file is extracted, remove this prefix from all paths. If it includes '{version}', it will be replaced with the version.",
        ),
        "filename_pattern": attr.string(
            default = "google_appengine_{version}.zip",
            mandatory = True,
            doc =
                "The filename of the SDK zip file to download. If it includes '{version}', it will be replaced with the version.",
        ),
    },
    local = False,
    implementation = _find_locally_or_download_impl,
)

def _appengine_download_cloud_sdk(repository_ctx):
    repository_ctx.download_and_extract(
        url = CLOUD_SDK_PLATFORM_ARCHIVE,
        output = ".",
        sha256 = CLOUD_SDK_PLATFORM_SHA256,
        stripPrefix = "google-cloud-sdk",
    )
    repository_ctx.template("BUILD", Label("//appengine:cloud_sdk.BUILD"))

appengine_download_cloud_sdk = repository_rule(
    local = False,
    implementation = _appengine_download_cloud_sdk,
)

def appengine_repositories():
    appengine_download_cloud_sdk(name = "com_google_cloud_sdk")
