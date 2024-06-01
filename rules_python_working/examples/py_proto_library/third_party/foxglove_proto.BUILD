load("@rules_python//python:proto.bzl", "py_proto_library")
load("@rules_proto//proto:defs.bzl", _proto_library = "proto_library")

proto_library(
    name = "foxglove_proto",
    srcs = glob(["foxglove/*.proto"]),
    deps = [
        "@com_google_protobuf//:timestamp_proto",
        "@com_google_protobuf//:duration_proto",
    ],
)

py_proto_library(
    name = "foxglove_py_proto",
    deps = [":foxglove_proto"],
    visibility = ["//visibility:public"],

)
