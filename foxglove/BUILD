load("@rules_python//python:defs.bzl", "py_test", "py_library")


py_library(
    name = "foxglove_py",
    deps = [
        "@foxglove_proto//:foxglove_py_proto",
    ],
    srcs = ["foxglove_test.py"],
)
py_test(
    name = "foxglove_test",
    srcs = [":foxglove_py"],
    deps = [
        "@foxglove_proto//:foxglove_py_proto",
    ],
    main = "foxglove_test.py"
)
