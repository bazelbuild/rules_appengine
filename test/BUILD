load("//appengine:appengine.bzl", "appengine_war")

appengine_war(
    name = "test-war",
    data = [":test-data"],
    data_path = "/test/data",
    jars = [":app_deploy.jar"],
)

java_binary(name="app", main_class="dummy")

filegroup(
    name = "test-data",
    srcs = glob(["data/**"]),
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
