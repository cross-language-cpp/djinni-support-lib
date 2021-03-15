cmake_minimum_required(VERSION 3.6.0)

set(CMAKE_CXX_STANDARD 11)

enable_testing()


file(GLOB_RECURSE CPP_GENERATED_SRCS "generated-src/cpp/*")
file(GLOB_RECURSE CPP_HANDWRITTEN_SRCS "handwritten-src/cpp/*")
source_group("generated-cpp" FILES ${CPP_GENERATED_SRCS})
source_group("handwritten-cpp" FILES ${CPP_HANDWRITTEN_SRCS})

file(GLOB_RECURSE JNI_GENERATED_SRCS "generated-src/jni/*")
file(GLOB_RECURSE JAVA_GENERATED_SRCS "generated-src/java/*")
file(GLOB_RECURSE JAVA_TEST_SRCS "handwritten-src/java/*")
source_group("generated-jni" FILES ${JNI_GENERATED_SRCS})
source_group("generated-java" FILES ${JAVA_GENERATED_SRCS})
source_group("java-tests" FILES ${JAVA_TEST_SRCS})

file(GLOB_RECURSE OBJC_GENERATED_SRCS "generated-src/objc/*")
file(GLOB_RECURSE OBJC_HANDWRITTEN_SRCS "handwritten-src/objc/impl/*")
file(GLOB_RECURSE OBJC_TEST_SRCS "handwritten-src/objc/tests/*")
source_group("generated-objc" FILES ${OBJC_GENERATED_SRCS})
source_group("handwritten-objc" FILES ${OBJC_HANDWRITTEN_SRCS})
source_group("objc-tests" FILES ${OBJC_TEST_SRCS})


if(DJINNI_WITH_JNI)
  set(support_dir ../djinni/jni)

  file(GLOB_RECURSE support_srcs ${support_dir}/*.cpp)

  add_library(DjinniTestNative SHARED
    ${support_srcs}
    ${JNI_GENERATED_SRCS}
    ${CPP_GENERATED_SRCS}
    ${CPP_HANDWRITTEN_SRCS}
  )
  target_include_directories(DjinniTestNative PRIVATE
    "generated-src/jni/"
    "generated-src/cpp/"
    "handwritten-src/cpp/"
    ${support_dir}
    ${JNI_INCLUDE_DIRS}
  )
  # target_link_libraries(DjinniTestNative ${JNI_LIBRARIES})

  find_package(Java REQUIRED)
  include(UseJava)

  add_jar(DjinniJavaTest
    SOURCES
      "../java/com/dropbox/djinni/NativeLibLoader.java"
      ${JAVA_GENERATED_SRCS}
      ${JAVA_TEST_SRCS}
    INCLUDE_JARS
      "${CMAKE_CURRENT_SOURCE_DIR}/deps/java/jsr305-3.0.0.jar"
      "${CMAKE_CURRENT_SOURCE_DIR}/deps/java/test/hamcrest-core-1.3.jar"
      "${CMAKE_CURRENT_SOURCE_DIR}/deps/java/test/junit-4.11.jar"
    # ENTRY_POINT "com.dropbox.djinni.test.AllTests"
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
    # -verbose #:jni
    -Xcheck:jni
    -Ddjinni.native_libs_dirs=$<TARGET_FILE:DjinniTestNative>
    # -jar ${_JAR_FILE}
    -cp ${_JAVA_TESTS_CLASSPATH}
    "com.dropbox.djinni.test.AllTests"
  )
endif()


if(DJINNI_WITH_OBJC)
  find_package(XCTest REQUIRED)

  add_library(DjinniObjcTest STATIC
    ${CPP_GENERATED_SRCS}
    ${CPP_HANDWRITTEN_SRCS}
    ${OBJC_GENERATED_SRCS}
    ${OBJC_HANDWRITTEN_SRCS}
  )

  target_include_directories(DjinniObjcTest PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/generated-src/cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/generated-src/objc
  )

  target_link_libraries(DjinniObjcTest djinni_support_lib)

  xctest_add_bundle(DjinniObjcTestTests DjinniObjcTest ${OBJC_TEST_SRCS})
  source_group("Tests" FILES ${OBJC_TEST_SRCS})
  target_include_directories(DjinniObjcTestTests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/objc/impl)

  xctest_add_test(XCTest.DjinniObjcTest DjinniObjcTestTests) 
endif()
