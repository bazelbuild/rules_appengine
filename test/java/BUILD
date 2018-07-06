load("//appengine:java_appengine.bzl", "appengine_war")

appengine_war(
    name = "test-war",
    testonly = 1,
    data = [
        ":web-inf",
        "//test/java/data:gen-data",
        "//test/java/data:test-data",
    ],
    data_path = "/test/java",
    jars = [":app_deploy.jar"],
)

java_binary(
    name = "app",
    main_class = "dummy",
)

sh_test(
    name = "check_war",
    srcs = ["check_war.sh"],
    args = ["$(JAVABASE)"],
    data = [
        ":test-war",
        "@bazel_tools//tools/jdk:current_java_runtime",
    ],
    toolchains = [
        "@bazel_tools//tools/jdk:current_java_runtime",
    ],
)

filegroup(
    name = "web-inf",
    srcs = glob(["WEB-INF/*"]),
)
