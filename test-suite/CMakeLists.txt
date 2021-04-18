cmake_minimum_required(VERSION 3.6.0)

if(DJINNI_WITH_OBJC)
  set(TEST_PROJECT_LANGUAGES OBJC OBJCXX)
elseif(DJINNI_WITH_CPPCLI)
  set(TEST_PROJECT_LANGUAGES CSharp)
endif()

project(djinni_support_lib_test CXX ${TEST_PROJECT_LANGUAGES})

set(CMAKE_CXX_STANDARD 11)

enable_testing()


include(Djinni.cmake)

add_djinni_target(DjinniAllTests
  IDL "djinni/all.djinni"
  IDL_INCLUDE_PATH "djinni/vendor"
  CPP_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/cpp"
  CPP_NAMESPACE "testsuite"
  IDENT_CPP_ENUM_TYPE "foo_bar"
  CPP_OPTIONAL_TEMPLATE "std::experimental::optional"
  CPP_OPTIONAL_HEADER "<experimental/optional>"
  CPP_OPTIONAL_HEADER "\"test-suite/handwritten-src/cpp/optional.hpp\""
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
  YAML_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/yaml"
  YAML_PREFIX "test_"

  CPP_OUT_FILES     CPP_GENERATED_SRCS
  JAVA_OUT_FILES    JAVA_GENERATED_SRCS
  JNI_OUT_FILES     JNI_GENERATED_SRCS
  OBJC_OUT_FILES    OBJC_GENERATED_SRCS
  OBJCPP_OUT_FILES  OBJCPP_GENERATED_SRCS
  CPPCLI_OUT_FILES  CPPCLI_GENERATED_SRCS
  YAML_OUT_FILE     YAML_GENERATED_SRCS
)

add_djinni_target(DjinniWCharTests
  IDL "djinni/wchar_test.djinni"
  CPP_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/cpp"
  CPP_NAMESPACE "testsuite"
  IDENT_CPP_ENUM_TYPE "foo_bar"
  CPP_OPTIONAL_TEMPLATE "std::experimental::optional"
  CPP_OPTIONAL_HEADER "<experimental/optional>"
  CPP_OPTIONAL_HEADER "\"test-suite/handwritten-src/cpp/optional.hpp\""
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
  IDENT_JNI_CLASS "NativeFooBar"
  IDENT_JNI_FILE "NativeFooBar"
  OBJC_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/objc"
  OBJC_TYPE_PREFIX "DB"
  OBJCPP_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/objc"
  CPPCLI_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/cppcli"
  CPPCLI_NAMESPACE "Djinni::TestSuite"
  CPPCLI_INCLUDE_CPP_PREFIX "cpp/"
  YAML_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/yaml"
  YAML_PREFIX "test_"

  CPP_OUT_FILES     WCHAR_CPP_GENERATED_SRCS
  JAVA_OUT_FILES    WCHAR_JAVA_GENERATED_SRCS
  JNI_OUT_FILES     WCHAR_JNI_GENERATED_SRCS
  OBJC_OUT_FILES    WCHAR_OBJC_GENERATED_SRCS
  OBJCPP_OUT_FILES  WCHAR_OBJCPP_GENERATED_SRCS
  CPPCLI_OUT_FILES  WCHAR_CPPCLI_GENERATED_SRCS
  YAML_OUT_FILE     WCHAR_YAML_GENERATED_SRCS
)


file(GLOB_RECURSE CPP_HANDWRITTEN_SRCS "handwritten-src/cpp/*")
file(GLOB_RECURSE JAVA_TEST_SRCS "handwritten-src/java/*")
file(GLOB_RECURSE OBJC_HANDWRITTEN_SRCS "handwritten-src/objc/impl/*")
file(GLOB_RECURSE OBJC_TEST_SRCS "handwritten-src/objc/tests/*")

source_group("handwritten-cpp"  FILES ${CPP_HANDWRITTEN_SRCS})
source_group("handwritten-objc" FILES ${OBJC_HANDWRITTEN_SRCS})
source_group("java-tests"       FILES ${JAVA_TEST_SRCS})
source_group("objc-tests"       FILES ${OBJC_TEST_SRCS})

source_group("generated-cpp"    FILES ${CPP_GENERATED_SRCS})
source_group("generated-java"   FILES ${JAVA_GENERATED_SRCS})
source_group("generated-jni"    FILES ${JNI_GENERATED_SRCS})
source_group("generated-objc"   FILES ${OBJC_GENERATED_SRCS})
source_group("generated-objcpp" FILES ${OBJCPP_GENERATED_SRCS})
source_group("generated-yaml"   FILES ${YAML_GENERATED_SRCS})

source_group("generated-cpp"    FILES ${WCHAR_CPP_GENERATED_SRCS})
source_group("generated-java"   FILES ${WCHAR_JAVA_GENERATED_SRCS})
source_group("generated-jni"    FILES ${WCHAR_JNI_GENERATED_SRCS})
source_group("generated-objc"   FILES ${WCHAR_OBJC_GENERATED_SRCS})
source_group("generated-objcpp" FILES ${WCHAR_OBJCPP_GENERATED_SRCS})
source_group("generated-yaml"   FILES ${WCHAR_YAML_GENERATED_SRCS})

if(DJINNI_WITH_JNI)
  file(GLOB_RECURSE SUPPORT_LIB_JNI_SRCS "${CMAKE_SOURCE_DIR}/djinni/jni/*")

  add_library(DjinniTestNative SHARED
    ${SUPPORT_LIB_JNI_SRCS}
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
  target_link_libraries(DjinniObjcTest djinni_support_lib)

  xctest_add_bundle(DjinniObjcTestTests DjinniObjcTest ${OBJC_TEST_SRCS})
  target_include_directories(DjinniObjcTestTests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/objc/impl)

  xctest_add_test(XCTest.DjinniObjcTest DjinniObjcTestTests) 
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
  target_link_libraries(DjinniCppCli djinni_support_lib)

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

  target_link_libraries(DjinniCppCliTest DjinniCppCli)
endif()
