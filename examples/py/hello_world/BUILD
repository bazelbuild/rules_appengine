"""
Example taken from the official App Engine examples:
https://github.com/GoogleCloudPlatform/python-docs-samples/tree/master/appengine/standard/hello_world
"""

load("@io_bazel_rules_appengine//appengine:py_appengine.bzl", "py_appengine_binary")


py_appengine_binary(
    name = "main",
    srcs = ["main.py"],
    configs = ["app.yaml"],
)
