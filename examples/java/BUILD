load("//appengine:java_appengine.bzl", "appengine_war")

appengine_war(
    name = "examples",
    data = [
        ":static.txt",
        "//examples/java/webapp",
    ],
    data_path = "/examples/java/webapp",
    jars = ["//examples/java/src:src_deploy.jar"],
)
