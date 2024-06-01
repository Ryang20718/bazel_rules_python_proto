# Copyright 2024 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

""

load("@rules_testing//lib:test_suite.bzl", "test_suite")
load("//python/private:whl_target_platforms.bzl", "select_whl", "select_whls")  # buildifier: disable=bzl-visibility

WHL_LIST = [
    "pkg-0.0.1-cp311-cp311-macosx_10_9_universal2.whl",
    "pkg-0.0.1-cp311-cp311-macosx_10_9_x86_64.whl",
    "pkg-0.0.1-cp311-cp311-macosx_11_0_arm64.whl",
    "pkg-0.0.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl",
    "pkg-0.0.1-cp311-cp311-manylinux_2_17_ppc64le.manylinux2014_ppc64le.whl",
    "pkg-0.0.1-cp311-cp311-manylinux_2_17_s390x.manylinux2014_s390x.whl",
    "pkg-0.0.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl",
    "pkg-0.0.1-cp311-cp311-manylinux_2_5_i686.manylinux1_i686.manylinux_2_17_i686.manylinux2014_i686.whl",
    "pkg-0.0.1-cp311-cp311-musllinux_1_1_aarch64.whl",
    "pkg-0.0.1-cp311-cp311-musllinux_1_1_i686.whl",
    "pkg-0.0.1-cp311-cp311-musllinux_1_1_ppc64le.whl",
    "pkg-0.0.1-cp311-cp311-musllinux_1_1_s390x.whl",
    "pkg-0.0.1-cp311-cp311-musllinux_1_1_x86_64.whl",
    "pkg-0.0.1-cp311-cp311-win32.whl",
    "pkg-0.0.1-cp311-cp311-win_amd64.whl",
    "pkg-0.0.1-cp37-cp37m-macosx_10_9_x86_64.whl",
    "pkg-0.0.1-cp37-cp37m-manylinux_2_17_aarch64.manylinux2014_aarch64.whl",
    "pkg-0.0.1-cp37-cp37m-manylinux_2_17_ppc64le.manylinux2014_ppc64le.whl",
    "pkg-0.0.1-cp37-cp37m-manylinux_2_17_s390x.manylinux2014_s390x.whl",
    "pkg-0.0.1-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl",
    "pkg-0.0.1-cp37-cp37m-manylinux_2_5_i686.manylinux1_i686.manylinux_2_17_i686.manylinux2014_i686.whl",
    "pkg-0.0.1-cp37-cp37m-musllinux_1_1_aarch64.whl",
    "pkg-0.0.1-cp37-cp37m-musllinux_1_1_i686.whl",
    "pkg-0.0.1-cp37-cp37m-musllinux_1_1_ppc64le.whl",
    "pkg-0.0.1-cp37-cp37m-musllinux_1_1_s390x.whl",
    "pkg-0.0.1-cp37-cp37m-musllinux_1_1_x86_64.whl",
    "pkg-0.0.1-cp37-cp37m-win32.whl",
    "pkg-0.0.1-cp37-cp37m-win_amd64.whl",
    "pkg-0.0.1-cp39-cp39-macosx_10_9_universal2.whl",
    "pkg-0.0.1-cp39-cp39-macosx_10_9_x86_64.whl",
    "pkg-0.0.1-cp39-cp39-macosx_11_0_arm64.whl",
    "pkg-0.0.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl",
    "pkg-0.0.1-cp39-cp39-manylinux_2_17_ppc64le.manylinux2014_ppc64le.whl",
    "pkg-0.0.1-cp39-cp39-manylinux_2_17_s390x.manylinux2014_s390x.whl",
    "pkg-0.0.1-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl",
    "pkg-0.0.1-cp39-cp39-manylinux_2_5_i686.manylinux1_i686.manylinux_2_17_i686.manylinux2014_i686.whl",
    "pkg-0.0.1-cp39-cp39-musllinux_1_1_aarch64.whl",
    "pkg-0.0.1-cp39-cp39-musllinux_1_1_i686.whl",
    "pkg-0.0.1-cp39-cp39-musllinux_1_1_ppc64le.whl",
    "pkg-0.0.1-cp39-cp39-musllinux_1_1_s390x.whl",
    "pkg-0.0.1-cp39-cp39-musllinux_1_1_x86_64.whl",
    "pkg-0.0.1-cp39-cp39-win32.whl",
    "pkg-0.0.1-cp39-cp39-win_amd64.whl",
    "pkg-0.0.1-cp39-abi3-any.whl",
    "pkg-0.0.1-py310-abi3-any.whl",
    "pkg-0.0.1-py3-abi3-any.whl",
    "pkg-0.0.1-py3-none-any.whl",
]

def _match(env, got, *want_filenames):
    if not want_filenames:
        env.expect.that_collection(got).has_size(len(want_filenames))
        return

    got_filenames = [g.filename for g in got]
    env.expect.that_collection(got_filenames).contains_exactly(want_filenames)

    if got:
        # Check that we pass the original structs
        env.expect.that_str(got[0].other).equals("dummy")

def _select_whl(**kwargs):
    """A small wrapper to make the tests more DRY."""
    got_single = select_whl(**kwargs)
    return [got_single] if got_single else []

def _select_whls(whls, **kwargs):
    return select_whls(
        whls = [
            struct(
                filename = f,
                other = "dummy",
            )
            for f in whls
        ],
        **kwargs
    )

_tests = []

def _test_simplest(env):
    got = _select_whls(
        whls = [
            "pkg-0.0.1-py2.py3-abi3-any.whl",
            "pkg-0.0.1-py3-abi3-any.whl",
            "pkg-0.0.1-py3-none-any.whl",
        ],
        want_abis = ["none"],
        want_platforms = ["ignored"],
    )
    _match(
        env,
        got,
        "pkg-0.0.1-py3-none-any.whl",
    )

_tests.append(_test_simplest)

def _test_select_abi3(env):
    got = _select_whls(
        whls = [
            "pkg-0.0.1-py2.py3-abi3-any.whl",
            "pkg-0.0.1-py3-abi3-any.whl",
            "pkg-0.0.1-py3-none-any.whl",
        ],
        want_abis = ["abi3"],
        want_platforms = ["ignored"],
    )
    _match(
        env,
        got,
        "pkg-0.0.1-py3-abi3-any.whl",
    )

_tests.append(_test_select_abi3)

def _test_select_by_supported_py_version(env):
    for want_python_version, match in {
        "3.11": "pkg-0.0.1-py311-abi3-any.whl",
        "3.8": "pkg-0.0.1-py3-abi3-any.whl",
    }.items():
        got = _select_whls(
            whls = [
                "pkg-0.0.1-py2.py3-abi3-any.whl",
                "pkg-0.0.1-py3-abi3-any.whl",
                "pkg-0.0.1-py311-abi3-any.whl",
            ],
            want_abis = ["abi3"],
            want_platforms = ["ignored"],
            want_python_version = want_python_version,
        )
        _match(env, got, match)

_tests.append(_test_select_by_supported_py_version)

def _test_select_by_supported_cp_version(env):
    for want_python_version, match in {
        "3.11": "pkg-0.0.1-cp311-abi3-any.whl",
        "3.8": "pkg-0.0.1-py3-abi3-any.whl",
    }.items():
        got = _select_whls(
            whls = [
                "pkg-0.0.1-py2.py3-abi3-any.whl",
                "pkg-0.0.1-py3-abi3-any.whl",
                "pkg-0.0.1-py311-abi3-any.whl",
                "pkg-0.0.1-cp311-abi3-any.whl",
            ],
            want_abis = ["abi3"],
            want_platforms = ["ignored"],
            want_python_version = want_python_version,
        )
        _match(env, got, match)

_tests.append(_test_select_by_supported_cp_version)

def _test_supported_cp_version_manylinux(env):
    for want_python_version, match in {
        "3.11": "pkg-0.0.1-cp311-none-manylinux_x86_64.whl",
        "3.8": "pkg-0.0.1-py3-none-manylinux_x86_64.whl",
    }.items():
        got = _select_whls(
            whls = [
                "pkg-0.0.1-py2.py3-none-manylinux_x86_64.whl",
                "pkg-0.0.1-py3-none-manylinux_x86_64.whl",
                "pkg-0.0.1-py311-none-manylinux_x86_64.whl",
                "pkg-0.0.1-cp311-none-manylinux_x86_64.whl",
            ],
            want_abis = ["none"],
            want_platforms = ["linux_x86_64"],
            want_python_version = want_python_version,
        )
        _match(env, got, match)

_tests.append(_test_supported_cp_version_manylinux)

def _test_ignore_unsupported(env):
    got = _select_whls(
        whls = [
            "pkg-0.0.1-xx3-abi3-any.whl",
        ],
        want_abis = ["abi3"],
        want_platforms = ["ignored"],
    )
    _match(env, got)

_tests.append(_test_ignore_unsupported)

def _test_match_abi_and_not_py_version(env):
    # Check we match the ABI and not the py version
    got = _select_whls(whls = WHL_LIST, want_abis = ["cp37m"], want_platforms = ["linux_x86_64"], want_python_version = "3.7")
    _match(
        env,
        got,
        "pkg-0.0.1-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl",
        "pkg-0.0.1-cp37-cp37m-musllinux_1_1_x86_64.whl",
    )
    got = _select_whl(whls = got, want_platform = "linux_x86_64")
    _match(env, got, "pkg-0.0.1-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")

_tests.append(_test_match_abi_and_not_py_version)

def _test_select_filename_with_many_tags(env):
    # Check we can select a filename with many platform tags
    got = _select_whls(whls = WHL_LIST, want_abis = ["cp39"], want_platforms = ["linux_x86_32"], want_python_version = "3.9")
    _match(
        env,
        got,
        "pkg-0.0.1-cp39-cp39-manylinux_2_5_i686.manylinux1_i686.manylinux_2_17_i686.manylinux2014_i686.whl",
        "pkg-0.0.1-cp39-cp39-musllinux_1_1_i686.whl",
    )
    got = _select_whl(whls = got, want_platform = "linux_x86_32")
    _match(env, got, "pkg-0.0.1-cp39-cp39-manylinux_2_5_i686.manylinux1_i686.manylinux_2_17_i686.manylinux2014_i686.whl")

_tests.append(_test_select_filename_with_many_tags)

def _test_osx_prefer_arch_specific(env):
    # Check that we prefer the specific wheel
    got = _select_whls(
        whls = WHL_LIST,
        want_abis = ["cp311"],
        want_platforms = ["osx_x86_64", "osx_x86_32"],
        want_python_version = "3.11",
    )
    _match(
        env,
        got,
        "pkg-0.0.1-cp311-cp311-macosx_10_9_universal2.whl",
        "pkg-0.0.1-cp311-cp311-macosx_10_9_x86_64.whl",
    )
    got = _select_whl(whls = got, want_platform = "osx_x86_64")
    _match(env, got, "pkg-0.0.1-cp311-cp311-macosx_10_9_x86_64.whl")

    got = _select_whls(whls = WHL_LIST, want_abis = ["cp311"], want_platforms = ["osx_aarch64"], want_python_version = "3.11")
    _match(
        env,
        got,
        "pkg-0.0.1-cp311-cp311-macosx_10_9_universal2.whl",
        "pkg-0.0.1-cp311-cp311-macosx_11_0_arm64.whl",
    )
    got = _select_whl(whls = got, want_platform = "osx_aarch64")
    _match(env, got, "pkg-0.0.1-cp311-cp311-macosx_11_0_arm64.whl")

_tests.append(_test_osx_prefer_arch_specific)

def _test_osx_fallback_to_universal2(env):
    # Check that we can use the universal2 if the arm wheel is not available
    got = _select_whls(whls = [w for w in WHL_LIST if "arm64" not in w], want_abis = ["cp311"], want_platforms = ["osx_aarch64"], want_python_version = "3.11")
    _match(
        env,
        got,
        "pkg-0.0.1-cp311-cp311-macosx_10_9_universal2.whl",
    )
    got = _select_whl(whls = got, want_platform = "osx_aarch64")
    _match(env, got, "pkg-0.0.1-cp311-cp311-macosx_10_9_universal2.whl")

_tests.append(_test_osx_fallback_to_universal2)

def _test_prefer_manylinux_wheels(env):
    # Check we prefer platform specific wheels
    got = _select_whls(whls = WHL_LIST, want_abis = ["none", "abi3", "cp39"], want_platforms = ["linux_x86_64"], want_python_version = "3.9")
    _match(
        env,
        got,
        "pkg-0.0.1-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl",
        "pkg-0.0.1-cp39-cp39-musllinux_1_1_x86_64.whl",
        "pkg-0.0.1-cp39-abi3-any.whl",
        "pkg-0.0.1-py3-none-any.whl",
    )
    got = _select_whl(whls = got, want_platform = "linux_x86_64")
    _match(env, got, "pkg-0.0.1-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")

_tests.append(_test_prefer_manylinux_wheels)

def select_whl_test_suite(name):
    """Create the test suite.

    Args:
        name: the name of the test suite
    """
    test_suite(name = name, basic_tests = _tests)
