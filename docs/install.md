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
# DJINNI_WITH_JNI, DJINNI_WITH_OBJC, DJINNI_WITH_PYTHON, DJINNI_WITH_CPPCLI
# In this example the target language depends on the target system:
if(ANDROID)
    set(DJINNI_WITH_JNI ON CACHE INTERNAL "")
elseif(CMAKE_SYSTEM_NAME IN_LIST "Darwin;iOS")
    set(DJINNI_WITH_OBJC ON CACHE INTERNAL "")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(DJINNI_WITH_CPPCLI ON CACHE INTERNAL "")
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
  GIT_TAG v1.0.0)
# set options for djinni-support-lib
set(DJINNI_BUILD_TESTING OFF CACHE INTERNAL "")
if(ANDROID)
    set(DJINNI_WITH_JNI ON CACHE INTERNAL "")
elseif(CMAKE_SYSTEM_NAME IN_LIST "Darwin;iOS")
    set(DJINNI_WITH_OBJC ON CACHE INTERNAL "")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(DJINNI_WITH_CPPCLI ON CACHE INTERNAL "")
endif()
FetchContent_MakeAvailable(djinni-support-lib)

add_library(foo ...)

target_link_libraries(foo PRIVATE djinni-support-lib::djinni-support-lib)
```

## Package Managers

### Conan

The library is available at [conan-center](https://conan.io/center/djinni-support-lib):

```text
[requires]
djinni-support-lib/1.0.0
```

#### Options

| Option | Values | Description |
| ------ | ------ | ----------- |
| `shared` | `True`, `False` | Wether to build as shared library. Default: `False` |
| `fPIC` | `True`, `False` | Default: `True`. Follows the default Conan behaviour. |
| `target` | `jni`, `objc`, `python`, `cppcli`, `auto` | The library has different targets for usage with Java, Objective-C, Python or C++/CLI. By default (`auto`) the target is determined automatically depending on the target OS (`iOS` → `objc`, `Android` → `jni`, `Windows` → `cppcli`). Set this explicitly if you want to build for `macOS`/`Windows`/`Linux`, because on these platforms multiple targets may be a valid option! |
| `system_java` | `True`, `False` | Wether `zulu-openjdk/11.0.8` should be installed from conan center if `target=jni`. Set to `True` to use the system JDK. (Default: `False`, Android: `True`)   |
