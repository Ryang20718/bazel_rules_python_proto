workspace(name = "bazel_rules_python_proto")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_python",
    sha256 = "62ddebb766b4d6ddf1712f753dac5740bea072646f630eb9982caa09ad8a7687",
    strip_prefix = "rules_python-0.39.0",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.39.0/rules_python-0.39.0.tar.gz",
)

# When not using this example in the rules_python git repo you would load the python
# rules using http_archive(), as documented in the release notes.

load("@rules_python//python:repositories.bzl", "py_repositories", "python_register_toolchains")

# We install the rules_python dependencies using the function below.
py_repositories()

python_register_toolchains(
    name = "python39",
    python_version = "3.9",
)

# Then we need to setup dependencies in order to use py_proto_library
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_proto",
    sha256 = "dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd",
    strip_prefix = "rules_proto-5.3.0-21.7",
    urls = [
        "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
    ],
)

http_archive(
    name = "com_google_protobuf",
    sha256 = "9a301cf94a8ddcb380b901e7aac852780b826595075577bb967004050c835056",
    strip_prefix = "protobuf-3.19.6",
    urls = ["https://github.com/protocolbuffers/protobuf/archive/refs/tags/v3.19.6.tar.gz"],
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

rules_proto_dependencies()

rules_proto_toolchains()


http_archive(
    name = "foxglove_proto",
    build_file = "//third_party:foxglove_proto.BUILD",
    sha256 = "84ff497d66f5340a8e9b2f9d6515a4ce54bc994223377a10223f0187d659b643",
    strip_prefix = "schemas-f028ba1154faa1226a9993cc2223855123dbf817/schemas/proto",
    url = "https://github.com/foxglove/schemas/archive/f028ba1154faa1226a9993cc2223855123dbf817.zip",
)
