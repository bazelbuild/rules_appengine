# Copyright 2015 The Bazel Authors. All rights reserved.
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
"""
Use of this file is deprecated. Use the functions in java_appengine.bzl directly.
"""

load(
    ":java_appengine.bzl",
    _appengine_war = "appengine_war",
    _appengine_war_base = "appengine_war_base",
    _java_appengine_repositories = "java_appengine_repositories",
    _java_war = "java_war",
)

appengine_war = _appengine_war

appengine_war_base = _appengine_war_base

java_appengine_repositories = _java_appengine_repositories

java_war = _java_war
