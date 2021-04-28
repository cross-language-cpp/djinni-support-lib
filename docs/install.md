# Installing the Support-Lib

## Conan

The library is available at [conan-center](https://conan.io/center/djinni-support-lib):

```text
[requires]
djinni-support-lib/0.1.0
```

### Options

| Option | Values | Description |
| ------ | ------ | ----------- |
| `shared` | `True`, `False` | Wether to build as shared library. Default: `False` |
| `fPIC` | `True`, `False` | Default: `True`. Follows the default Conan behaviour. |
| `target` | `jni`, `objc`, `python`, `cppcli`, `auto` | The library has different targets for usage with Java, Objective-C, Python or C++/CLI. By default (`auto`) the target is determined automatically depending on the target OS (`iOS` → `objc`, `Android` → `jni`, `Windows` → `cppcli`). Set this explicitly if you want to build for `macOS`/`Windows`/`Linux`, because on these platforms multiple targets may be a valid option! |
| `system_java` | `True`, `False` | The library needs to link against the JNI (Java Native Interface) if `target` is `jni`. By default (`True`), `zulu-openjdk/11.0.8` will be installed from conan center for this. Set to `False` to use the systems Java installation instead.  |
| `jni_with_main` | `True`, `False` | Wether to include [a default `JNI_OnLoad` implementation](https://github.com/cross-language-cpp/djinni-support-lib/blob/main/djinni/jni/djinni_main.cpp#L23) that initializes Djinni. If set to `False`, a custom `JNI_OnLoad` implementation has to be provided. Default: `True` |
