cmake_minimum_required(VERSION 3.6.0)

set(CMAKE_CXX_STANDARD 17)

if(APPLE)
    set(MACOSX_RPATH TRUE)
    set(CMAKE_MACOSX_RPATH ${CMAKE_CURRENT_BINARY_DIR})
endif()

enable_testing()

add_djinni_target(DjinniTextSort
  IDL "example.djinni"
#  IDL_INCLUDE_PATH "djinni/vendor"
  CPP_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/cpp"
  CPP_NAMESPACE "textsort"
  IDENT_CPP_ENUM_TYPE "foo_bar"
  CPP_EXTENDED_RECORD_INCLUDE_PREFIX "handwritten-src/cpp/"
  CPP_ENUM_HASH_WORKAROUND
  JAVA_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/java"
  JAVA_PACKAGE "com.dropbox.textsort"
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
  TS_OUT "${CMAKE_CURRENT_BINARY_DIR}/generated-src/ts"
  TS_MODULE "example"
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

if(DJINNI_WITH_WASM)
  set(DjinniTextsortWasm "textsort-wasm")

  set(CPP_HANDWRITTEN_SRCS 
      ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp/sort_items_impl.cpp
  )

  add_executable(${DjinniTextsortWasm} 
      ${CPP_HANDWRITTEN_SRCS}
      ${CPP_GENERATED_SRCS}
      ${WASM_GENERATED_SRCS}
      ${TS_GENERATED_SRCS}
    )
    target_include_directories(${DjinniTextsortWasm} PUBLIC
      ${CMAKE_SOURCE_DIR}
      ${CMAKE_CURRENT_SOURCE_DIR}/handwritten-src/cpp
      ${CMAKE_CURRENT_BINARY_DIR}/generated-src/cpp
      ${CMAKE_CURRENT_BINARY_DIR}/generated-src/wasm
    )

    set(WASM_CC_FLAGS "-s MAIN_MODULE=1 -fexceptions")
    message(WARNING ${WASM_CC_FLAGS})
    set_target_properties(${DjinniTextsortWasm} PROPERTIES COMPILE_FLAGS ${WASM_CC_FLAGS})
    
    string(JOIN " " EMSCRIPTEN_LINK_OPTIONS
      "-s WASM=1"
      "--bind"  # Compiles the source code using the Embind bindings to connect C/C++ and JavaScript
      "-s MALLOC=emmalloc"  # Switch to using the much smaller implementation
      "-s MODULARIZE=1"  # Allows us to manually invoke the initialization of wasm
      "-s WASM_BIGINT=1" # We need to pass int64_t
    )

    set(WASM_LINK_FLAGS "${EMSCRIPTEN_LINK_OPTIONS} -fexceptions")
    message(WARNING ${WASM_LINK_FLAGS})
    set_target_properties(${DjinniTextsortWasm} PROPERTIES LINK_FLAGS ${WASM_LINK_FLAGS})
    set(CMAKE_EXECUTABLE_SUFFIX ".js")
    
    target_link_libraries(${DjinniTextsortWasm} PUBLIC djinni-support-lib::djinni-support-lib embind)

    add_custom_target(DjinniTextsortWasmCopy)
    file(GLOB DjinniTextsortWasmResources ${CMAKE_CURRENT_SOURCE_DIR}/ts/*)
    foreach(ResourceFile ${DjinniTextsortWasmResources})
      add_custom_command(TARGET ${DjinniTextsortWasm} PRE_BUILD
                        COMMAND ${CMAKE_COMMAND} -E
                            copy ${ResourceFile} $<TARGET_FILE_DIR:${DjinniTextsortWasm}>)
    endforeach()
    add_dependencies(${DjinniTextsortWasm} DjinniTextsortWasmCopy)

    # add_test(NAME DjinniWasmTestTests COMMAND bash -c "${CMAKE_CURRENT_BINARY_DIR}/run.sh")

endif()
