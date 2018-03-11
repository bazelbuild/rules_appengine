package(
    default_visibility = ["//test/java:__pkg__"],
    default_testonly = 1,
)

filegroup(
    name = "test-data",
    srcs = glob(["*"]),
)

genrule(
    name = "gen-data",
    cmd = "echo hi > $@",
    outs = ["gen-data.out"],
)
