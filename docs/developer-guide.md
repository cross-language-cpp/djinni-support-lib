# Developer guide

!!! info

    This chapter is only interesting if you intend to make changes to the code of djinni-support-lib

## Building from source

### Build dependencies

- Djinni generator (compatible version specified in `.tool-versions`)
- Java JDK 8 or 11

### Building

Make sure you have the `JAVA_HOME` environment variable properly set, e.g.:

```bash
export JAVA_HOME=$(/usr/libexec/java_home)
```

For an out of source build:

```bash
mkdir -p build && cd build
cmake -DDJINNI_WITH_JNI=1 -DDJINNI_WITH_OBJC=1 ..
cmake --build . --parallel
```

A custom `djinni` executable can be specified with the CMake option
`DJINNI_EXECUTABLE_PATH`.

### Running Tests

#### Java, Objective-C

```bash
cd build/test-suite
ctest
```

#### C++/CLI

1. Generate Visual Studio Solution with `-G "Visual Studio 16 2019"`:
    ```sh
    cmake -S . -B build -DDJINNI_WITH_CPPCLI=ON -DDJINNI_STATIC_LIB=ON -G "Visual Studio 16 2019"
    ```
2. Open the solution `djinni_support_lib.sln` in Visual Studio.
3. Build `DjinniCppCliTest`.
4. Run the tests: <kbd>Test</kbd> > <kbd>Run All Tests</kbd>.

## Release process

To release a new version of the support-lib, the following steps must be followed:

1. Create a [new release](https://github.com/cross-language-cpp/djinni-support-lib/releases/new) on Github like [described here](https://docs.github.com/en/github/administering-a-repository/managing-releases-in-a-repository).
   Set a tag version following [semantic versioning](https://semver.org/) rules (`v<MAJOR>.<MINOR>.<PATCH>`) and describe what has changed in the new version.
3. Create a PR to the [conan-center-index](https://github.com/conan-io/conan-center-index/tree/master/recipes/djinni-support-lib) to publish the new version to [Conan Center](https://conan.io/center/djinni-support-lib).
