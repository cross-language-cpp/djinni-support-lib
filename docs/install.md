# Installing the Support-Lib

## CMake

### Embedded

To embed the library directly into an existing CMake project, place the entire source tree in a subdirectory and call
`add_subdirectory()` in your `CMakeLists.txt` file:

```cmake
project(foo)
# disable tests
set(DJINNI_BUILD_TESTING OFF CACHE INTERNAL "")
# choose for which target language the djinni-support-lib should be compiled.
# At least one of the following options must be set to true:
# DJINNI_WITH_JNI, DJINNI_WITH_OBJC
# In this example the target language depends on the target system:
if(ANDROID)
    set(DJINNI_WITH_JNI ON CACHE INTERNAL "")
elseif(CMAKE_SYSTEM_NAME IN_LIST "Darwin;iOS")
    set(DJINNI_WITH_OBJC ON CACHE INTERNAL "")
endif()
add_subdirectory(thirdparty/djinni-support-lib)

add_library(foo ...)

target_link_libraries(foo PRIVATE djinni-support-lib::djinni-support-lib)
```

### Embedded (FetchContent)

[FetchContent](https://cmake.org/cmake/help/v3.14/module/FetchContent.html) can be used to automatically download the repository as a dependency at configuration time.

```cmake
cmake_minimum_required(VERSION 3.14)
include(FetchContent)
project(foo)

FetchContent_Declare(djinni-support-lib
  GIT_REPOSITORY https://github.com/cross-language-cpp/djinni-support-lib.git
  GIT_TAG v1.2.1)
# set options for djinni-support-lib
set(DJINNI_BUILD_TESTING OFF CACHE INTERNAL "")
if(ANDROID)
    set(DJINNI_WITH_JNI ON CACHE INTERNAL "")
elseif(CMAKE_SYSTEM_NAME IN_LIST "Darwin;iOS")
    set(DJINNI_WITH_OBJC ON CACHE INTERNAL "")
endif()
FetchContent_MakeAvailable(djinni-support-lib)

add_library(foo ...)

target_link_libraries(foo PRIVATE djinni-support-lib::djinni-support-lib)
```

## Package Managers

### Conan

(deprecated)

The library is available at [conan-center](https://conan.io/center/djinni-support-lib):

```text
[requires]
djinni-support-lib/1.2.1
```

#### Options

| Option | Values | Description |
| ------ | ------ | ----------- |
| `shared` | `True`, `False` | Wether to build as shared library. Default: `False` |
| `fPIC` | `True`, `False` | Default: `True`. Follows the default Conan behaviour. |
| `target` | `deprecated` | *Do not use the target option anymore! It exists just to stay compatible to old versions of the recipe and will be removed.* |
| `with_jni` | `True`, `False`, `auto` | Default: `auto`. Wether to build JNI bindings or not. `auto` means `True` for Android builds, `False` for other platforms. |
| `with_objc` | `True`, `False`, `auto` | Default: `auto`. Wether to build Objective-C bindings or not. `auto` means `True` for any Darwin platform (iOS, macOS, ...), `False` false other platforms. |
| `system_java` | `True`, `False` | Wether `zulu-openjdk/11.0.8` should be installed from conan center if `target=jni`. Set to `True` to use the system JDK. (Default: `False`, Android: `True`)   |
