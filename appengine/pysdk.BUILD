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
    name = "webapp2-2.5.2",
    srcs = glob(["lib/webapp2-2.5.2/**/*.py"]),
    deps = [":webob-1.2.3"],
    imports = ["lib/webapp2-2.5.2"]
)

py_library(
    name = "webob-1.2.3",
    srcs = glob(["lib/webob-1.2.3/**/*.py"]),
    imports = ["lib/webob-1.2.3"]
)

py_library(
    name = "webapp2-latest",
    deps = [":webapp2-2.5.2"],
)

py_library(
    name = "webob-latest",
    deps = [":webob-1.2.3"],
)
