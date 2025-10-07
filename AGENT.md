# Bazel build

I want a bazel build for this djinni-support-library

Some AI gave it already a try, but produced mostly garbage.
Simplify the overengeneerd BUILD.bazel, and check the rest

Please explore the existing CMake file and do what is required so I can `bazel build ...` and `bazel test ...`
on this mac, and per default, i get both, objective c and jni binding

## Existing CMake build

see CMakeLists.txt in the project root folder

Info, the CMake build is run by

```sh
sh zconf-new.sh
cmake --build build/new --config Debug
(cd build/new && ctest . -C Debug)
```

## Goals

- we want modern Bazel, no workspace stuff, bazel 8.4 and above
- I want to libraries, djinni-jni and djinni-objc, there can be a djinni-base that always links and is internal
- Test are using those libraries,
- No fuzz in the .bazelrc except what is heavily needed, use the default debug and release configs,
- keep in mind, we want in future select if we build jni and / or objc

## Implementation

We work stage wise, one stage after another.

## Stage 1

make the libs build on my Mac

this is an example for a (probably old) BUILD file

```bazel
load("@rules_cc//cc:defs.bzl", "cc_library", "objc_library")

cc_library(
    name = "djinni-base",
    srcs = [
        "djinni/cwrapper/wrapper_marshal.cpp",
    ],
    hdrs = [
        "djinni/cwrapper/wrapper_marshal.h",
        "djinni/cwrapper/wrapper_marshal.hpp",
        "djinni/djinni_common.hpp",
        "djinni/proxy_cache_impl.hpp",
        "djinni/proxy_cache_interface.hpp",
    ],
    copts = ["--std=c++17"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "djinni-jni",
    srcs = [
        "djinni/jni/djinni_jni_main.cpp",
        "djinni/jni/djinni_support.cpp",
    ],
    hdrs = [
        "djinni/jni/Marshal.hpp",
        "djinni/jni/djinni_jni_main.hpp",
        "djinni/jni/djinni_support.hpp",
    ],
    copts = ["--std=c++17"],
    linkstatic = True,
    visibility = ["//visibility:public"],
    deps = [
        ":djinni-base",
        "@bazel_tools//tools/jdk:jni", # TODO , not needed in Android build
    ],
    alwayslink = 1,
)

objc_library(
    name = "djinni-objc",
    srcs = [
        "djinni/objc/DJICppWrapperCache+Private.h",
        "djinni/objc/DJIError.mm",
        "djinni/objc/DJIMarshal+Private.h",
        "djinni/objc/DJIObjcWrapperCache+Private.h",
        "djinni/objc/DJIProxyCaches.mm",
    ],
    hdrs = [
        "djinni/objc/DJIError.h",
    ],
    copts = [
        "-ObjC++",
    ],
    visibility = ["//visibility:public"],
    deps = [":djinni-base"],
)
```

stay to something like this

## Stage 2

make selectable, if we are on Mac, we have objective-c and jni selectable (or, de-selectable)

on non mac, objective-c shall not exist

## Stage 3

Discuss how to add testing. Testing needs the djinni-generator , which is available in this repo/branch
https://github.com/a4z/djinni-generator/tree/build/bzl

That provides it with a bazel build.

Testing might, by itself needed to be added iterative, that will be defined after the discussion.

## Stage 4

- I want to be able to filp that against the default developer version in ../djinni-generator
- we look at jni for android
