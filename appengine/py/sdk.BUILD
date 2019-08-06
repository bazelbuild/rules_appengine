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

# BUILD file to use the Python AppEngine SDK with a remote repository.
package(default_visibility = ["//visibility:public"])

py_library(
    name = "appengine",
    srcs = glob(["**/*.py"]),
    data = glob(
        ["**/*"],
        exclude = ["**/*.py"],
    ),
)

py_binary(
    name = "dev_appserver",
    srcs = ["dev_appserver.py"],
    deps = [":appengine"],
)

py_binary(
    name = "appcfg",
    srcs = ["appcfg.py"],
    deps = [":appengine"],
)

py_library(
    name = "endpoints-1.0",
    srcs = glob(["lib/endpoints-1.0/**/*.py"]),
    imports = ["lib/endpoints-1.0"],
    deps = [":protorpc-1.0"],
)

py_library(
    name = "fancy_urllib",
    srcs = glob(["lib/fancy_urllib/**/*.py"]),
    imports = ["lib/fancy_urllib"],
)

py_library(
    name = "jinja2-2.6",
    srcs = glob(["lib/jinja2-2.6/jinja2/**/*.py"]),
    imports = ["lib/jinja2-2.6"],
)

py_library(
    name = "markupsafe-0.15",
    srcs = glob(["lib/markupsafe-0.15/**/*.py"]),
    imports = ["lib/markupsafe-0.15"],
)

py_library(
    name = "markupsafe-0.23",
    srcs = glob(["lib/markupsafe-0.23/**/*.py"]),
    imports = ["lib/markupsafe-0.23"],
)

py_library(
    name = "protorpc-1.0",
    srcs = glob(["lib/protorpc-1.0/**/*.py"]),
    imports = ["lib/protorpc-1.0"],
)

py_library(
    name = "PyAMF-0.6.1",
    srcs = glob(["lib/PyAMF-0.6.1/**/*.py"]),
    imports = ["lib/PyAMF-0.6.1"],
)

py_library(
    name = "PyAMF-0.7.2",
    srcs = glob(["lib/PyAMF-0.7.2/**/*.py"]),
    imports = ["lib/PyAMF-0.7.2"],
)

py_library(
    name = "webapp2-2.5.2",
    srcs = glob(["lib/webapp2-2.5.2/**/*.py"]),
    imports = ["lib/webapp2-2.5.2"],
    deps = [":webob-1.2.3"],
)

py_library(
    name = "webob-1.2.3",
    srcs = glob(["lib/webob-1.2.3/**/*.py"]),
    imports = ["lib/webob-1.2.3"],
)

py_library(
    name = "werkzeug-0.11.10",
    srcs = glob(["lib/werkzeug-0.11.10/**/*.py"]),
    imports = ["lib/werkzeug-0.11.10"],
)

py_library(
    name = "yaml-3.10",
    srcs = glob(["lib/yaml-3.10/**/*.py"]),
    imports = ["lib/yaml-3.10"],
)

py_library(
    name = "endpoints-latest",
    deps = [":endpoints-1.0"],
)

py_library(
    name = "fancy_urllib-latest",
    deps = [":fancy_urllib"],
)

py_library(
    name = "jinja2-latest",
    deps = [":jinja2-2.6"],
)

py_library(
    name = "markupsafe-latest",
    deps = [":markupsafe-0.23"],
)

py_library(
    name = "protorpc-latest",
    deps = [":protorpc-1.0"],
)

py_library(
    name = "PyAMF-latest",
    deps = [":PyAMF-0.7.2"],
)

py_library(
    name = "webapp2-latest",
    deps = [":webapp2-2.5.2"],
)

py_library(
    name = "webob-latest",
    deps = [":webob-1.2.3"],
)

py_library(
    name = "werkzeug-latest",
    deps = [":werkzeug-0.11.10"],
)

py_library(
    name = "yaml-latest",
    deps = [":yaml-3.10"],
)
