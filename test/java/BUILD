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
    data = [
        ":test-war",
        "@local_jdk//:jar",
        "@local_jdk//:jdk-default",
    ],
)

filegroup(
    name = "web-inf",
    srcs = glob(["WEB-INF/*"]),
)
