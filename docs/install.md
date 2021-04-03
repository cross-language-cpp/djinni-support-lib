# Installing the Support-Lib

## Conan

The library is available at [conan-center](https://conan.io/center/djinni-support-lib):

```sh
conan install djinni-support-lib/0.0.1@
```

### Options

| Option | Values | Description |
| ------ | ------ | ----------- |
| `shared` | `True`, `False` | Wether to build as shared library. Default: `False` |
| `fPIC` | `True`, `False` | Default: `True`. Follows the default Conan behaviour. |
| `target` | `jni`, `objc`, `auto` | The library has different targets for usage with Java or Objective-C. By default (`auto`) the target is determined automatically depending on the target OS (`iOS` → `objc`, `Android` → `jni`). Set this explicitly if you want to build for `macOS`/`Windows`/`Linux`, because on these platforms both targets may be a valid option! |
| `system_java` | `True`, `False` | The library needs to link against the JNI (Java Native Interface) if `target` is `jni`. By default (`True`), `zulu-openjdk/11.0.8` will be installed from conan center for this. Set to `False` to use the systems Java installation instead.  |
