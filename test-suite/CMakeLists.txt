cmake_minimum_required(VERSION 3.6.0)

set(CMAKE_CXX_STANDARD 17)

if(APPLE)
    set(MACOSX_RPATH TRUE)
    set(CMAKE_MACOSX_RPATH ${CMAKE_CURRENT_BINARY_DIR})
endif()

enable_testing()

add_djinni_target(DjinniAllTests
  IDL "djinni/all.djinni"
  IDL_INCLUDE_PATH "djinni/vendor"
  CPP_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/cpp"
  CPP_NAMESPACE "testsuite"
  IDENT_CPP_ENUM_TYPE "foo_bar"
  CPP_EXTENDED_RECORD_INCLUDE_PREFIX "test-suite/handwritten-src/cpp/"
  CPP_ENUM_HASH_WORKAROUND
  JAVA_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/java"
  JAVA_PACKAGE "com.dropbox.djinni.test"
  JAVA_GENERATE_INTERFACES
  JAVA_IMPLEMENT_ANDROID_OS_PARCELABLE
  JAVA_NULLABLE_ANNOTATION "javax.annotation.CheckForNull"
  JAVA_NONNULL_ANNOTATION "javax.annotation.Nonnull"
  IDENT_JAVA_FIELD "mFooBar"
  JNI_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/jni"
  IDENT_JNI_CLASS "NativeFooBar"
  IDENT_JNI_FILE "NativeFooBar"
  OBJC_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/objc"
  OBJC_TYPE_PREFIX "DB"
  OBJCPP_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/objc"
  CPPCLI_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/cppcli"
  CPPCLI_NAMESPACE "Djinni::TestSuite"
  CPPCLI_INCLUDE_CPP_PREFIX "cpp/"
  WASM_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/wasm"
  WASM_NAMESPACE "testsuite"
  TS_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/ts"
  TS_MODULE "test"
  YAML_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/yaml"
  YAML_PREFIX "test_"

  CPP_OUT_FILES     CPP_GENERATED_SRCS
  JAVA_OUT_FILES    JAVA_GENERATED_SRCS
  JNI_OUT_FILES     JNI_GENERATED_SRCS
  OBJC_OUT_FILES    OBJC_GENERATED_SRCS
  OBJCPP_OUT_FILES  OBJCPP_GENERATED_SRCS
  CPPCLI_OUT_FILES  CPPCLI_GENERATED_SRCS
  WASM_OUT_FILES    WASM_GENERATED_SRCS
  TS_OUT_FILES      TS_GENERATED_SRCS
  YAML_OUT_FILE     YAML_GENERATED_SRCS
)

add_djinni_target(DjinniWCharTests
  IDL "djinni/wchar_test.djinni"
  CPP_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/cpp"
  CPP_NAMESPACE "testsuite"
  IDENT_CPP_ENUM_TYPE "foo_bar"
  CPP_EXTENDED_RECORD_INCLUDE_PREFIX "test-suite/handwritten-src/cpp/"
  CPP_ENUM_HASH_WORKAROUND
  CPP_USE_WIDE_STRINGS
  JAVA_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/java"
  JAVA_PACKAGE "com.dropbox.djinni.test"
  JAVA_GENERATE_INTERFACES
  JAVA_IMPLEMENT_ANDROID_OS_PARCELABLE
  JAVA_NULLABLE_ANNOTATION "javax.annotation.CheckForNull"
  JAVA_NONNULL_ANNOTATION "javax.annotation.Nonnull"
  IDENT_JAVA_FIELD "mFooBar"
  JNI_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/jni"
  JNI_GENERATE_MAIN false
  IDENT_JNI_CLASS "NativeFooBar"
  IDENT_JNI_FILE "NativeFooBar"
  OBJC_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/objc"
  OBJC_TYPE_PREFIX "DB"
  OBJCPP_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/objc"
  CPPCLI_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/cppcli"
  CPPCLI_NAMESPACE "Djinni::TestSuite"
  CPPCLI_INCLUDE_CPP_PREFIX "cpp/"
  WASM_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/wasm"
  WASM_NAMESPACE "testsuite"
  TS_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/ts"
  TS_MODULE "test_wchar"
  TS_SUPPORT_FILES_OUT "${CMAKE_CURRENT_BINARY_DIR}/ts-support-lib"
  YAML_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/yaml"
  YAML_PREFIX "test_"

  CPP_OUT_FILES     WCHAR_CPP_GENERATED_SRCS
  JAVA_OUT_FILES    WCHAR_JAVA_GENERATED_SRCS
  JNI_OUT_FILES     WCHAR_JNI_GENERATED_SRCS
  OBJC_OUT_FILES    WCHAR_OBJC_GENERATED_SRCS
  OBJCPP_OUT_FILES  WCHAR_OBJCPP_GENERATED_SRCS
  CPPCLI_OUT_FILES  WCHAR_CPPCLI_GENERATED_SRCS
  WASM_OUT_FILES    WCHAR_WASM_GENERATED_SRCS
  TS_OUT_FILES      WCHAR_TS_GENERATED_SRCS
  YAML_OUT_FILE     WCHAR_YAML_GENERATED_SRCS
)

add_djinni_target(DjinniPyTests
  IDL "djinni/py_all.djinni"
  PY_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/python"
  PYCFFI_PACKAGE_NAME "PyCFFIlib"
  PYCFFI_DYNAMIC_LIB_LIST "mylib"
  PYCFFI_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/cffi"
  C_WRAPPER_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/cwrapper"
  CPP_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/pycpp"
  CPP_NAMESPACE "testsuite"
  IDENT_CPP_ENUM_TYPE "foo_bar"
  PY_OUT_FILES         PYTHON_GENERATED_SRCS
  PYCFFI_OUT_FILES     PYCFFI_GENERATED_SRCS
  C_WRAPPER_OUT_FILES  C_WRAPPER_GENERATED_SRCS
  CPP_OUT_FILES        PYCPP_GENERATED_SRCS
)

file(GLOB_RECURSE CPP_HANDWRITTEN_SRCS "handwritten-src/cpp/*")
file(GLOB_RECURSE JAVA_TEST_SRCS "handwritten-src/java/*")
file(GLOB_RECURSE OBJC_HANDWRITTEN_SRCS "handwritten-src/objc/impl/*")
file(GLOB_RECURSE OBJC_TEST_SRCS "handwritten-src/objc/tests/*")
file(GLOB_RECURSE C_WRAPPER_HANDWRITTEN_SRCS "handwritten-src/cwrapper/*")
file(GLOB_RECURSE PYCPP_HANDWRITTEN_SRCS "handwritten-src/pycpp/*")
file(GLOB_RECURSE WASM_HANDWRITTEN_SRCS "handwritten-src/wasm/*")
file(GLOB_RECURSE TS_HANDWRITTEN_SRCS "handwritten-src/ts/*")

source_group("handwritten-cpp"  FILES ${CPP_HANDWRITTEN_SRCS})
source_group("handwritten-objc" FILES ${OBJC_HANDWRITTEN_SRCS})
source_group("java-tests"       FILES ${JAVA_TEST_SRCS})
source_group("objc-tests"       FILES ${OBJC_TEST_SRCS})
source_group("wasm-tests")

source_group("generated-cpp"    FILES ${CPP_GENERATED_SRCS})
source_group("generated-java"   FILES ${JAVA_GENERATED_SRCS})
source_group("generated-jni"    FILES ${JNI_GENERATED_SRCS})
source_group("generated-objc"   FILES ${OBJC_GENERATED_SRCS})
source_group("generated-objcpp" FILES ${OBJCPP_GENERATED_SRCS})
source_group("generated-wasm"   FILES ${WASM_GENERATED_SRCS})
source_group("generated-ts"     FILES ${TS_GENERATED_SRCS})
source_group("generated-yaml"   FILES ${YAML_GENERATED_SRCS})

source_group("generated-cpp"    FILES ${WCHAR_CPP_GENERATED_SRCS})
source_group("generated-java"   FILES ${WCHAR_JAVA_GENERATED_SRCS})
source_group("generated-jni"    FILES ${WCHAR_JNI_GENERATED_SRCS})
source_group("generated-objc"   FILES ${WCHAR_OBJC_GENERATED_SRCS})
source_group("generated-objcpp" FILES ${WCHAR_OBJCPP_GENERATED_SRCS})
source_group("generated-wasm"   FILES ${WCHAR_WASM_GENERATED_SRCS})
source_group("generated-ts"     FILES ${WCHAR_TS_GENERATED_SRCS})
source_group("generated-yaml"   FILES ${WCHAR_YAML_GENERATED_SRCS})

if(DJINNI_WITH_JNI)
  add_library(DjinniTestNative SHARED
    ${JNI_GENERATED_SRCS}
    ${CPP_GENERATED_SRCS}
    ${WCHAR_JNI_GENERATED_SRCS}
    ${WCHAR_CPP_GENERATED_SRCS}
    ${CPP_HANDWRITTEN_SRCS}
  )
  target_include_directories(DjinniTestNative PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp
    ${CMAKE_CURRENT_BINARY_DIR}/generated-src/jni
    ${CMAKE_CURRENT_BINARY_DIR}/generated-src/cpp
    ${JNI_INCLUDE_DIRS}
  )
  target_link_libraries(DjinniTestNative PUBLIC djinni-support-lib::djinni-support-lib)

  find_package(Java REQUIRED)
  include(UseJava)

  add_jar(DjinniJavaTest
    SOURCES
      "../java/com/dropbox/djinni/NativeLibLoader.java"
      ${JAVA_GENERATED_SRCS}
      ${WCHAR_JAVA_GENERATED_SRCS}
      ${JAVA_TEST_SRCS}
    INCLUDE_JARS
      "${CMAKE_CURRENT_SOURCE_DIR}/deps/java/jsr305-3.0.0.jar"
      "${CMAKE_CURRENT_SOURCE_DIR}/deps/java/test/hamcrest-core-1.3.jar"
      "${CMAKE_CURRENT_SOURCE_DIR}/deps/java/test/junit-4.11.jar"
  )
  get_target_property(_JAR_FILE DjinniJavaTest JAR_FILE)
  get_target_property(_CLASSDIR DjinniJavaTest CLASSDIR)

  string(CONCAT _JAVA_TESTS_CLASSPATH
    "${CMAKE_CURRENT_SOURCE_DIR}/deps/java/jsr305-3.0.0.jar:"
    "${CMAKE_CURRENT_SOURCE_DIR}/deps/java/test/hamcrest-core-1.3.jar:"
    "${CMAKE_CURRENT_SOURCE_DIR}/deps/java/test/junit-4.11.jar:"
    "${_CLASSDIR}"
  )

  add_test(NAME DjinniJavaTestTests COMMAND ${Java_JAVA_EXECUTABLE}
    -Xcheck:jni
    -Ddjinni.native_libs_dirs=$<TARGET_FILE:DjinniTestNative>
    -cp ${_JAVA_TESTS_CLASSPATH}
    "com.dropbox.djinni.test.AllTests"
  )
endif()


if(DJINNI_WITH_OBJC)
  find_package(XCTest REQUIRED)

  add_library(DjinniObjcTest STATIC
    ${CPP_HANDWRITTEN_SRCS}
    ${OBJC_HANDWRITTEN_SRCS}
    ${CPP_GENERATED_SRCS}
    ${OBJC_GENERATED_SRCS}
    ${OBJCPP_GENERATED_SRCS}
    ${WCHAR_CPP_GENERATED_SRCS}
    ${WCHAR_OBJC_GENERATED_SRCS}
    ${WCHAR_OBJCPP_GENERATED_SRCS}
  )
  target_include_directories(DjinniObjcTest PUBLIC
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp
    ${CMAKE_CURRENT_BINARY_DIR}/generated-src/cpp
    ${CMAKE_CURRENT_BINARY_DIR}/generated-src/objc
  )
  target_link_libraries(DjinniObjcTest PUBLIC djinni-support-lib::djinni-support-lib)
  xctest_add_bundle(DjinniObjcTestTests DjinniObjcTest ${OBJC_TEST_SRCS})
  target_include_directories(DjinniObjcTestTests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/objc/impl)

  xctest_add_test(XCTest.DjinniObjcTest DjinniObjcTestTests)
endif()


if(DJINNI_WITH_WASM)
  set(DjinniWasmTest "test-wasm")

  add_executable(${DjinniWasmTest} 
      ${CPP_HANDWRITTEN_SRCS}
      ${CPP_GENERATED_SRCS}
      ${WASM_GENERATED_SRCS}
      ${TS_GENERATED_SRCS}
      ${WCHAR_CPP_GENERATED_SRCS}
      ${WCHAR_WASM_GENERATED_SRCS}
      ${WCHAR_TS_GENERATED_SRCS}
    )
    target_include_directories(${DjinniWasmTest} PUBLIC
      ${CMAKE_SOURCE_DIR}
      ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp
      ${CMAKE_CURRENT_BINARY_DIR}/generated-src/cpp
      ${CMAKE_CURRENT_BINARY_DIR}/generated-src/wasm
    )

    set(WASM_CC_FLAGS "-s MAIN_MODULE=1 -fexceptions")
    set_target_properties(${DjinniWasmTest} PROPERTIES COMPILE_FLAGS ${WASM_CC_FLAGS})
    
    string(JOIN " " EMSCRIPTEN_LINK_OPTIONS
      "-s WASM=1"
      "--bind"  # Compiles the source code using the Embind bindings to connect C/C++ and JavaScript
      "-s MALLOC=emmalloc"  # Switch to using the much smaller implementation
      "-s MODULARIZE=1"  # Allows us to manually invoke the initialization of wasm
      "-s WASM_BIGINT=1" # We need to pass int64_t
    )

    set(WASM_LINK_FLAGS "${EMSCRIPTEN_LINK_OPTIONS} -fexceptions")
    set_target_properties(${DjinniWasmTest} PROPERTIES LINK_FLAGS ${WASM_LINK_FLAGS})
    set(CMAKE_EXECUTABLE_SUFFIX ".js")
    
    target_link_libraries(${DjinniWasmTest} PUBLIC djinni-support-lib::djinni-support-lib embind)

    add_custom_target(DjinniWasmTestCopy)
    file(GLOB DjinniWasmTestResources ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/ts/*)
    foreach(ResourceFile ${DjinniWasmTestResources})
      add_custom_command(TARGET ${DjinniWasmTest} PRE_BUILD
                        COMMAND ${CMAKE_COMMAND} -E
                            copy ${ResourceFile} $<TARGET_FILE_DIR:${DjinniWasmTest}>)
    endforeach()
    add_dependencies(${DjinniWasmTest} DjinniWasmTestCopy)

    add_test(NAME DjinniWasmTestTests COMMAND bash -c "${CMAKE_CURRENT_BINARY_DIR}/run.sh")

endif()


if(DJINNI_WITH_PYTHON)
  # There's no YAML support in Djinni for Python yet.
  set(FILTERED_CPP_HANDWRITTEN_SRCS ${CPP_HANDWRITTEN_SRCS})
  list(REMOVE_ITEM FILTERED_CPP_HANDWRITTEN_SRCS
    "${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp/TranslateDuration.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp/flag_roundtrip.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp/wchar_test_helpers.cpp"
  )

  add_library(mylib SHARED
    ${FILTERED_CPP_HANDWRITTEN_SRCS}
    ${C_WRAPPER_HANDWRITTEN_SRCS}
    ${PYCPP_HANDWRITTEN_SRCS}
    ${C_WRAPPER_GENERATED_SRCS}
    ${PYCPP_GENERATED_SRCS}
  )
  target_include_directories(mylib PUBLIC
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/pycpp
    ${CMAKE_CURRENT_BINARY_DIR}/generated-src/pycpp
  )
  target_link_libraries(mylib PUBLIC djinni-support-lib::djinni-support-lib)

  # Prepare Python 3 environment
  find_package(PythonInterp "3" REQUIRED)
  if (WIN32)
    message(WARNING "Python support on Windwos is not fully implemented, for more details visit https://github.com/cross-language-cpp/djinni-support-lib/issues")
    string(JOIN $<SEMICOLON> PYTHONPATH
    "${CMAKE_SOURCE_DIR}/djinni/py"
    "${CMAKE_CURRENT_BINARY_DIR}/generated-src/python"
    $ENV{PYTHONPATH})
  else()
    string(JOIN ":" PYTHONPATH
      "${CMAKE_SOURCE_DIR}/djinni/py"
      "${CMAKE_CURRENT_BINARY_DIR}/generated-src/python"
      $ENV{PYTHONPATH})
  endif()
  
  # Compile Python extension module (CFFI)
  set(C_WRAPPER_GENERATED_HEADERS ${C_WRAPPER_GENERATED_SRCS})
  list(FILTER C_WRAPPER_GENERATED_HEADERS INCLUDE REGEX "\\.h$")
  add_custom_target(PyCFFIlib_cffi ALL
    ${CMAKE_COMMAND} -E env PYTHONPATH=${PYTHONPATH} LIBRARY_PATH=$<TARGET_FILE_DIR:mylib> ${PYTHON_EXECUTABLE}
        ${PYCFFI_GENERATED_SRCS}
        ${CMAKE_SOURCE_DIR}/djinni/cwrapper/wrapper_marshal.h
        ${C_WRAPPER_GENERATED_HEADERS}
        ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cwrapper/limits_helper.h
    DEPENDS mylib ${PYCFFI_GENERATED_SRCS} ${PYTHON_GENERATED_SRCS} ${C_WRAPPER_GENERATED_HEADERS}
    COMMENT "Building CFFI lib"
    VERBATIM
    WORKING_DIRECTORY $<TARGET_FILE_DIR:mylib>
  )

  add_test(NAME PythonTests COMMAND ${CMAKE_COMMAND} -E env PYTHONPATH=${PYTHONPATH}
    ${PYTHON_EXECUTABLE} -m pytest -s "${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/python"
  )
endif()

if(DJINNI_WITH_CPPCLI)
  add_library(DjinniCppCli SHARED
    ${CPP_HANDWRITTEN_SRCS}
    ${CPP_GENERATED_SRCS}
    ${CPPCLI_GENERATED_SRCS}
    ${WCHAR_CPP_GENERATED_SRCS}
    ${WCHAR_CPPCLI_GENERATED_SRCS}
  )
  target_include_directories(DjinniCppCli PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src
    ${CMAKE_CURRENT_BINARY_DIR}/generated-src/cpp
    ${CMAKE_CURRENT_BINARY_DIR}/generated-src
  )
  set_target_properties(DjinniCppCli PROPERTIES
    VS_DOTNET_REFERENCES "System;System.Core"
    COMMON_LANGUAGE_RUNTIME ""
  )
  target_link_libraries(DjinniCppCli PUBLIC djinni-support-lib::djinni-support-lib)

  add_library(DjinniCppCliTest SHARED
    handwritten-src/cs/ClientInterfaceImpl.cs
    handwritten-src/cs/ClientInterfaceTest.cs
    handwritten-src/cs/CppExceptionTest.cs
    handwritten-src/cs/DurationTest.cs
    handwritten-src/cs/EnumTest.cs
    handwritten-src/cs/MapRecordTest.cs
    handwritten-src/cs/MockRecordTest.cs
    handwritten-src/cs/NestedCollectionTest.cs
    handwritten-src/cs/PrimitiveListTest.cs
    handwritten-src/cs/PrimitivesTest.cs
    handwritten-src/cs/RecordWithDerivingsTest.cs
    handwritten-src/cs/SetRecordTest.cs
    handwritten-src/cs/TokenTest.cs
    handwritten-src/cs/WcharTest.cs
  )
  set_target_properties(DjinniCppCliTest PROPERTIES
    VS_DOTNET_REFERENCES "System;System.Core"
    VS_PACKAGE_REFERENCES "nunit_3.13.1;NUnit3TestAdapter_3.17.0;Microsoft.NET.Test.Sdk_16.9.4"
  )

  target_link_libraries(DjinniCppCliTest PUBLIC DjinniCppCli)
endif()
