# BUILD file to use the Java AppEngine SDK with a remote repository.
java_import(
    name = "jars",
    jars = glob(["lib/**/*.jar"]),
    visibility = ["//visibility:public"],
)

java_import(
    name = "user",
    jars = glob(["lib/user/*.jar"]),
    visibility = ["//visibility:public"],
)

java_import(
    name = "api",
    jars = [
        "lib/appengine-tools-api.jar",
        "lib/impl/appengine-api.jar",
    ],
    neverlink = 1,
    visibility = ["//visibility:public"],
)

filegroup(
    name = "sdk",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)
