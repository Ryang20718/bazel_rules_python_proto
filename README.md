# 

TO repro
```bash
USE_BAZEL_VERSION=7.1.2 bazelisk test //foxglove:all --noenable_bzlmod --announce_rc -s --sandbox_debug


....
Traceback (most recent call last):
  File "/tmp/bazel-working-directory/__main__/bazel-out/k8-fastbuild/bin/foxglove/foxglove_test.runfiles/__main__/foxglove/foxglove_test.py", line 6, in <module>
    from foxglove.Pose_pb2 import Pose as FoxglovePosePb
ModuleNotFoundError: No module named 'foxglove.Pose_pb2'; 'foxglove' is not a package
```


However, from rules_python's example it seems that this works fine?
the rules_python commit is based off https://github.com/bazelbuild/rules_python/commit/b4b52fc89a58e6b7d5d0675b0661a09f932ec37e (main June 1, 2024)
```
cd rules_python_repo/examples/py_proto_library/ && USE_BAZEL_VERSION=7.1.2 bazelisk test //foxglove:all --noenable_bzlmod --announce_rc -s --sandbox_debug
```
