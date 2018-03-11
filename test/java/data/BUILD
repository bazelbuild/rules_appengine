package(
    default_testonly = 1,
    default_visibility = ["//test/java:__pkg__"],
)

filegroup(
    name = "test-data",
    srcs = glob(["*"]),
)

genrule(
    name = "gen-data",
    outs = ["gen-data.out"],
    cmd = "echo hi > $@",
)
