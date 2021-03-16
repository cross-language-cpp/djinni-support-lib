# Developer guide

!!! info

    This chapter is only interesting if you intend to make changes to the code of djinni generator

## Building from source

### Build dependencies

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

### Running Tests

```bash
cd build/test-suite
ctest
```

or with the Makefile shortcut:

```bash
make test
```

