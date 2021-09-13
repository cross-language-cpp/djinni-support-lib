cmake_minimum_required(VERSION 3.18)

# find Djinni executable.
# On windows find_program() does not work for finding the `djinni.bat` script.
# The script must either be on the PATH or `DJINNI_EXECUTABLE` must explicitly be predefined.
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
  if(NOT DEFINED CACHE{DJINNI_EXECUTABLE})
    set(DJINNI_EXECUTABLE djinni.bat CACHE FILEPATH "path of djinni binary")
  endif()
else()
  find_program(DJINNI_EXECUTABLE djinni REQUIRED)
endif()

execute_process(COMMAND ${DJINNI_EXECUTABLE} "--version" OUTPUT_VARIABLE DJINNI_VERSION)
string(REGEX REPLACE "\n+$" "" DJINNI_VERSION "${DJINNI_VERSION}")
message(STATUS "Found Djinni: ${DJINNI_EXECUTABLE} (${DJINNI_VERSION})")


macro(append_if_defined LIST OPTION)
  if(NOT "${ARGN}" STREQUAL "")
    list(APPEND ${LIST} ${OPTION} ${ARGN})
  endif()
  set(${LIST} ${${LIST}} PARENT_SCOPE)
endmacro()

macro(append_option_flag LIST OPTION)
  string(TOLOWER ${ARGN} FLAG_VALUE)
  list(APPEND ${LIST} ${OPTION} ${FLAG_VALUE})
  set(${LIST} ${${LIST}} PARENT_SCOPE)
endmacro()


macro(resolve_djinni_inputs)
  set(SINGLE_VALUE RESULT)
  set(MULTI_VALUE COMMAND)
  cmake_parse_arguments(DJINNI "" "${SINGLE_VALUE}" "${MULTI_VALUE}" "${ARGN}")

  set(DJINNI_INPUTS_TXT "${CMAKE_CURRENT_BINARY_DIR}/djinni_inputs.txt")
  execute_process(
    COMMAND ${DJINNI_COMMAND} "--skip-generation" "true" "--list-in-files" "${DJINNI_INPUTS_TXT}"
    RESULT_VARIABLE DJINNI_CONFIGURATION_RESULT
    ERROR_VARIABLE DJINNI_STDERR
    OUTPUT_QUIET
  )
  if(DJINNI_CONFIGURATION_RESULT)
    message(FATAL_ERROR ${DJINNI_STDERR})
  endif()

  file(STRINGS ${DJINNI_INPUTS_TXT} ${DJINNI_RESULT})
endmacro()

macro(resolve_djinni_outputs)
  set(SINGLE_VALUE RESULT)
  set(MULTI_VALUE COMMAND)
  cmake_parse_arguments(DJINNI "" "${SINGLE_VALUE}" "${MULTI_VALUE}" "${ARGN}")

  set(DJINNI_OUTPUTS_TXT "${CMAKE_CURRENT_BINARY_DIR}/${DJINNI_RESULT}.txt")

  execute_process(
    COMMAND ${DJINNI_COMMAND} "--skip-generation" "true" "--list-out-files" "${DJINNI_OUTPUTS_TXT}"
    RESULT_VARIABLE DJINNI_CONFIGURATION_RESULT
    ERROR_VARIABLE DJINNI_STDERR
    OUTPUT_QUIET
  )
  if(DJINNI_CONFIGURATION_RESULT)
    message(FATAL_ERROR ${DJINNI_STDERR})
  endif()

  file(STRINGS ${DJINNI_OUTPUTS_TXT} ${DJINNI_RESULT})
endmacro()


function(add_djinni_target)
  set(OPTIONS
    SKIP_GENERATION   # TODO Not used.

    JAVA_GENERATE_INTERFACES
    JAVA_IMPLEMENT_ANDROID_OS_PARCELABLE
    JAVA_USE_FINAL_FOR_RECORD

    CPP_ENUM_HASH_WORKAROUND
    CPP_USE_WIDE_STRINGS

    OBJC_CLOSED_ENUMS
  )
  set(SINGLE_VALUE
    IDL

    JAVA_OUT
    JAVA_OUT_FILES
    JAVA_PACKAGE
    JAVA_CLASS_ACCESS_MODIFIER
    JAVA_CPP_EXCEPTION
    JAVA_ANNOTATION
    JAVA_NULLABLE_ANNOTATION
    JAVA_NONNULL_ANNOTATION
    IDENT_JAVA_ENUM
    IDENT_JAVA_FIELD
    IDENT_JAVA_TYPE

    JNI_OUT
    JNI_OUT_FILES
    JNI_HEADER_OUT
    JNI_INCLUDE_PREFIX
    JNI_INCLUDE_CPP_PREFIX
    JNI_NAMESPACE
    JNI_GENERATE_MAIN
    IDENT_JNI_CLASS
    IDENT_JNI_FILE

    CPP_OUT
    CPP_OUT_FILES
    CPP_HEADER_OUT
    CPP_INCLUDE_PREFIX
    CPP_NAMESPACE
    CPP_EXT
    HPP_EXT
    CPP_OPTIONAL_TEMPLATE
    CPP_OPTIONAL_HEADER
    CPP_NN_HEADER
    CPP_NN_TYPE
    CPP_NN_CHECK_EXPRESSION
    IDENT_CPP_ENUM
    IDENT_CPP_FIELD
    IDENT_CPP_METHOD
    IDENT_CPP_TYPE
    IDENT_CPP_ENUM_TYPE
    IDENT_CPP_TYPE_PARAM
    IDENT_CPP_LOCAL
    IDENT_CPP_FILE

    OBJC_OUT
    OBJC_OUT_FILES
    OBJC_HEADER_OUT
    OBJC_H_EXT
    OBJC_TYPE_PREFIX
    OBJC_INCLUDE_PREFIX
    OBJC_SWIFT_BRIDGING_HEADER
    IDENT_OBJC_ENUM
    IDENT_OBJC_FIELD
    IDENT_OBJC_METHOD
    IDENT_OBJC_TYPE
    IDENT_OBJC_TYPE_PARAM
    IDENT_OBJC_LOCAL
    IDENT_OBJC_FILE

    OBJCPP_OUT
    OBJCPP_OUT_FILES
    OBJCPP_EXT
    OBJCPP_INCLUDE_PREFIX
    OBJCPP_INCLUDE_CPP_PREFIX
    OBJCPP_INCLUDE_OBJC_PREFIX
    CPP_EXTENDED_RECORD_INCLUDE_PREFIX
    OBJC_EXTENDED_RECORD_INCLUDE_PREFIX
    OBJCPP_NAMESPACE

    PY_OUT
    PY_OUT_FILES
    PY_IMPORT_PREFIX
    PYCFFI_OUT
    PYCFFI_OUT_FILES
    PYCFFI_PACKAGE_NAME
    PYCFFI_DYNAMIC_LIB_LIST
    C_WRAPPER_OUT
    C_WRAPPER_OUT_FILES
    IDENT_PY_TYPE
    IDENT_PY_CLASS_NAME
    IDENT_PY_TYPE_PARAM
    IDENT_PY_METHOD
    IDENT_PY_FIELD
    IDENT_PY_LOCAL
    IDENT_PY_ENUM
    IDENT_PY_CONST


    CPPCLI_OUT
    CPPCLI_OUT_FILES
    CPPCLI_NAMESPACE
    CPPCLI_INCLUDE_CPP_PREFIX

    YAML_OUT
    YAML_OUT_FILE
    YAML_PREFIX
  )
  set(MULTI_VALUE
    IDL_INCLUDE_PATH
  )
  cmake_parse_arguments(DJINNI "${OPTIONS}" "${SINGLE_VALUE}" "${MULTI_VALUE}" "${ARGN}")

  get_filename_component(DJINNI_IDL "${DJINNI_IDL}" ABSOLUTE)
  get_filename_component(DJINNI_IDL_INCLUDE_PATH "${DJINNI_IDL_INCLUDE_PATH}" ABSOLUTE)
  set(DJINNI_ARGS "--idl" "${DJINNI_IDL}" "--idl-include-path" "${DJINNI_IDL_INCLUDE_PATH}")

  set(DJINNI_GENERATION_COMMAND ${DJINNI_EXECUTABLE} ${DJINNI_ARGS})
  resolve_djinni_inputs(COMMAND "${DJINNI_GENERATION_COMMAND}" RESULT DJINNI_INPUTS)

  append_if_defined(DJINNI_GENERATION_COMMAND "--cpp-include-prefix" ${DJINNI_CPP_INCLUDE_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--cpp-namespace" ${DJINNI_CPP_NAMESPACE})
  append_if_defined(DJINNI_GENERATION_COMMAND "--cpp-ext" ${DJINNI_CPP_EXT})
  append_if_defined(DJINNI_GENERATION_COMMAND "--hpp-ext" ${DJINNI_HPP_EXT})
  append_if_defined(DJINNI_GENERATION_COMMAND "--cpp-optional-template" ${DJINNI_CPP_OPTIONAL_TEMPLATE})
  append_if_defined(DJINNI_GENERATION_COMMAND "--cpp-optional-header" ${DJINNI_CPP_OPTIONAL_HEADER})
  append_if_defined(DJINNI_GENERATION_COMMAND "--cpp-nn-header" ${DJINNI_CPP_NN_HEADER})
  append_if_defined(DJINNI_GENERATION_COMMAND "--cpp-nn-type" ${DJINNI_CPP_NN_TYPE})
  append_if_defined(DJINNI_GENERATION_COMMAND "--cpp-nn-check-expression" ${DJINNI_CPP_NN_CHECK_EXPRESSION})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-cpp-enum" ${DJINNI_IDENT_CPP_ENUM})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-cpp-field" ${DJINNI_IDENT_CPP_FIELD})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-cpp-method" ${DJINNI_IDENT_CPP_METHOD})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-cpp-type" ${DJINNI_IDENT_CPP_TYPE})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-cpp-enum-type" ${DJINNI_IDENT_CPP_ENUM_TYPE})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-cpp-type-param" ${DJINNI_IDENT_CPP_TYPE_PARAM})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-cpp-local" ${DJINNI_IDENT_CPP_LOCAL})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-cpp-file" ${DJINNI_IDENT_CPP_FILE})
  append_option_flag(DJINNI_GENERATION_COMMAND "--cpp-enum-hash-workaround" ${DJINNI_CPP_ENUM_HASH_WORKAROUND})
  append_option_flag(DJINNI_GENERATION_COMMAND "--cpp-use-wide-strings" ${DJINNI_CPP_USE_WIDE_STRINGS})

  append_if_defined(DJINNI_GENERATION_COMMAND "--java-package" ${DJINNI_JAVA_PACKAGE})
  append_if_defined(DJINNI_GENERATION_COMMAND "--java-class-access-modifier" ${DJINNI_JAVA_CLASS_ACCESS_MODIFIER})
  append_if_defined(DJINNI_GENERATION_COMMAND "--java-cpp-exception" ${DJINNI_JAVA_CPP_EXCEPTION})
  append_if_defined(DJINNI_GENERATION_COMMAND "--java-annotation" ${DJINNI_JAVA_ANNOTATION})
  append_if_defined(DJINNI_GENERATION_COMMAND "--java-nullable-annotation" ${DJINNI_JAVA_NULLABLE_ANNOTATION})
  append_if_defined(DJINNI_GENERATION_COMMAND "--java-nonnull-annotation" ${DJINNI_JAVA_NONNULL_ANNOTATION})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-java-enum" ${DJINNI_IDENT_JAVA_ENUM})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-java-field" ${DJINNI_IDENT_JAVA_FIELD})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-java-type" ${DJINNI_IDENT_JAVA_TYPE})
  append_option_flag(DJINNI_GENERATION_COMMAND "--java-generate-interfaces" ${DJINNI_JAVA_GENERATE_INTERFACES})
  append_option_flag(DJINNI_GENERATION_COMMAND "--java-implement-android-os-parcelable" ${DJINNI_JAVA_IMPLEMENT_ANDROID_OS_PARCELABLE})
  append_option_flag(DJINNI_GENERATION_COMMAND "--java-use-final-for-record" ${DJINNI_JAVA_USE_FINAL_FOR_RECORD})

  append_if_defined(DJINNI_GENERATION_COMMAND "--jni-include-prefix" ${DJINNI_JNI_INCLUDE_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--jni-include-cpp-prefix" ${DJINNI_JNI_INCLUDE_CPP_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--jni-namespace" ${DJINNI_JNI_NAMESPACE})
  append_if_defined(DJINNI_GENERATION_COMMAND "--jni-generate-main" ${DJINNI_JNI_GENERATE_MAIN})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-jni-class" ${DJINNI_IDENT_JNI_CLASS})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-jni-file" ${DJINNI_IDENT_JNI_FILE})

  append_if_defined(DJINNI_GENERATION_COMMAND "--objc-h-ext" ${DJINNI_OBJC_H_EXT})
  append_if_defined(DJINNI_GENERATION_COMMAND "--objc-type-prefix" ${DJINNI_OBJC_TYPE_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--objc-include-prefix" ${DJINNI_OBJC_INCLUDE_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--objc-swift-bridging-header" ${DJINNI_OBJC_SWIFT_BRIDGING_HEADER})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-objc-enum" ${DJINNI_IDENT_OBJC_ENUM})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-objc-field" ${DJINNI_IDENT_OBJC_FIELD})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-objc-method" ${DJINNI_IDENT_OBJC_METHOD})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-objc-type" ${DJINNI_IDENT_OBJC_TYPE})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-objc-type-param" ${DJINNI_IDENT_OBJC_TYPE_PARAM})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-objc-local" ${DJINNI_IDENT_OBJC_LOCAL})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-objc-file" ${DJINNI_IDENT_OBJC_FILE})
  append_option_flag(DJINNI_GENERATION_COMMAND "--objc-closed-enums" ${DJINNI_OBJC_CLOSED_ENUMS})

  append_if_defined(DJINNI_GENERATION_COMMAND "--objcpp-ext" ${DJINNI_OBJCPP_EXT})
  append_if_defined(DJINNI_GENERATION_COMMAND "--objcpp-include-prefix" ${DJINNI_OBJCPP_INCLUDE_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--objcpp-include-cpp-prefix" ${DJINNI_OBJCPP_INCLUDE_CPP_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--objcpp-include-objc-prefix" ${DJINNI_OBJCPP_INCLUDE_OBJC_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--cpp-extended-record-include-prefix" ${DJINNI_CPP_EXTENDED_RECORD_INCLUDE_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--objc-extended-record-include-prefix" ${DJINNI_OBJC_EXTENDED_RECORD_INCLUDE_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--objcpp-namespace" ${DJINNI_OBJCPP_NAMESPACE})

  append_if_defined(DJINNI_GENERATION_COMMAND "--py-import-prefix" ${DJINNI_PY_IMPORT_PREFIX})
  append_if_defined(DJINNI_GENERATION_COMMAND "--pycffi-package-name" ${DJINNI_PYCFFI_PACKAGE_NAME})
  append_if_defined(DJINNI_GENERATION_COMMAND "--pycffi-dynamic-lib-list" ${DJINNI_PYCFFI_DYNAMIC_LIB_LIST})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-py-type" ${DJINNI_IDENT_PY_TYPE})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-py-class-name" ${DJINNI_IDENT_PY_CLASS_NAME})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-py-type-param" ${DJINNI_IDENT_PY_TYPE_PARAM})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-py-method" ${DJINNI_IDENT_PY_METHOD})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-py-field" ${DJINNI_IDENT_PY_FIELD})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-py-local" ${DJINNI_IDENT_PY_LOCAL})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-py-enum" ${DJINNI_IDENT_PY_ENUM})
  append_if_defined(DJINNI_GENERATION_COMMAND "--ident-py-const" ${DJINNI_IDENT_PY_CONST})

  append_if_defined(DJINNI_GENERATION_COMMAND "--cppcli-namespace" ${DJINNI_CPPCLI_NAMESPACE})
  append_if_defined(DJINNI_GENERATION_COMMAND "--cppcli-include-cpp-prefix" ${DJINNI_CPPCLI_INCLUDE_CPP_PREFIX})

  if(DEFINED DJINNI_CPP_OUT_FILES)
    set(DJINNI_CPP_GENERATION_COMMAND ${DJINNI_GENERATION_COMMAND})
    append_if_defined(DJINNI_CPP_GENERATION_COMMAND "--cpp-out" ${DJINNI_CPP_OUT})
    append_if_defined(DJINNI_CPP_GENERATION_COMMAND "--cpp-header-out" ${DJINNI_CPP_HEADER_OUT})

    resolve_djinni_outputs(COMMAND "${DJINNI_CPP_GENERATION_COMMAND}" RESULT CPP_OUT_FILES)

    add_custom_command(
      OUTPUT ${CPP_OUT_FILES}
      DEPENDS ${DJINNI_INPUTS}
      COMMAND ${DJINNI_CPP_GENERATION_COMMAND}
      COMMENT "Generating Djinni C++ bindings from ${DJINNI_IDL}"
      VERBATIM
    )
    set(${DJINNI_CPP_OUT_FILES} ${CPP_OUT_FILES} PARENT_SCOPE)
  endif()

  if(DEFINED DJINNI_JAVA_OUT_FILES)
    set(DJINNI_JAVA_GENERATION_COMMAND ${DJINNI_GENERATION_COMMAND})
    append_if_defined(DJINNI_JAVA_GENERATION_COMMAND "--java-out" ${DJINNI_JAVA_OUT})

    resolve_djinni_outputs(COMMAND "${DJINNI_JAVA_GENERATION_COMMAND}" RESULT JAVA_OUT_FILES)

    add_custom_command(
      OUTPUT ${JAVA_OUT_FILES}
      DEPENDS ${DJINNI_INPUTS}
      COMMAND ${DJINNI_JAVA_GENERATION_COMMAND}
      COMMENT "Generating Djinni Java bindings from ${DJINNI_IDL}"
      VERBATIM
    )
    set(${DJINNI_JAVA_OUT_FILES} ${JAVA_OUT_FILES} PARENT_SCOPE)
  endif()

  if (DEFINED DJINNI_JNI_OUT_FILES)
    set(DJINNI_JNI_GENERATION_COMMAND ${DJINNI_GENERATION_COMMAND})
    append_if_defined(DJINNI_JNI_GENERATION_COMMAND "--jni-out" ${DJINNI_JNI_OUT})
    append_if_defined(DJINNI_JNI_GENERATION_COMMAND "--jni-header-out" ${DJINNI_JNI_HEADER_OUT})

    resolve_djinni_outputs(COMMAND "${DJINNI_JNI_GENERATION_COMMAND}" RESULT JNI_OUT_FILES)

    add_custom_command(
      OUTPUT ${JNI_OUT_FILES}
      DEPENDS ${DJINNI_INPUTS}
      COMMAND ${DJINNI_JNI_GENERATION_COMMAND}
      # COMMENT "Generating Djinni JNI bindings from ${DJINNI_IDL}"
      COMMENT "Generating Djinni JNI bindings from ${DJINNI_IDL}: ${DJINNI_JNI_GENERATION_COMMAND}"
      VERBATIM
    )
    set(${DJINNI_JNI_OUT_FILES} ${JNI_OUT_FILES} PARENT_SCOPE)
  endif()

  if(DEFINED DJINNI_OBJC_OUT_FILES)
    set(DJINNI_OBJC_GENERATION_COMMAND ${DJINNI_GENERATION_COMMAND})
    append_if_defined(DJINNI_OBJC_GENERATION_COMMAND "--objc-out" ${DJINNI_OBJC_OUT})
    append_if_defined(DJINNI_OBJC_GENERATION_COMMAND "--objc-header-out" ${DJINNI_OBJC_HEADER_OUT})

    resolve_djinni_outputs(COMMAND "${DJINNI_OBJC_GENERATION_COMMAND}" RESULT OBJC_OUT_FILES)

    add_custom_command(
      OUTPUT ${OBJC_OUT_FILES}
      DEPENDS ${DJINNI_INPUTS}
      COMMAND ${DJINNI_OBJC_GENERATION_COMMAND}
      COMMENT "Generating Djinni Objective-C bindings from ${DJINNI_IDL}"
      VERBATIM
    )
    set(${DJINNI_OBJC_OUT_FILES} ${OBJC_OUT_FILES} PARENT_SCOPE)
  endif()

  if(DEFINED DJINNI_OBJCPP_OUT_FILES)
    set(DJINNI_OBJCPP_GENERATION_COMMAND ${DJINNI_GENERATION_COMMAND})
    append_if_defined(DJINNI_OBJCPP_GENERATION_COMMAND "--objcpp-out" ${DJINNI_OBJCPP_OUT})

    resolve_djinni_outputs(COMMAND "${DJINNI_OBJCPP_GENERATION_COMMAND}" RESULT OBJCPP_OUT_FILES)

    add_custom_command(
      OUTPUT ${OBJCPP_OUT_FILES}
      DEPENDS ${DJINNI_INPUTS}
      COMMAND ${DJINNI_OBJCPP_GENERATION_COMMAND}
      COMMENT "Generating Djinni Objective-C++ bindings from ${DJINNI_IDL}"
      VERBATIM
    )
    set(${DJINNI_OBJCPP_OUT_FILES} ${OBJCPP_OUT_FILES} PARENT_SCOPE)
  endif()

  if(DEFINED DJINNI_PY_OUT_FILES)
    set(DJINNI_PY_GENERATION_COMMAND ${DJINNI_GENERATION_COMMAND})
    append_if_defined(DJINNI_PY_GENERATION_COMMAND "--py-out" ${DJINNI_PY_OUT})

    resolve_djinni_outputs(COMMAND "${DJINNI_PY_GENERATION_COMMAND}" RESULT PY_OUT_FILES)

    add_custom_command(
      OUTPUT ${PY_OUT_FILES}
      DEPENDS ${DJINNI_INPUTS}
      COMMAND ${DJINNI_PY_GENERATION_COMMAND}
      COMMENT "Generating Djinni Python bindings from ${DJINNI_IDL}"
      VERBATIM
    )
    set(${DJINNI_PY_OUT_FILES} ${PY_OUT_FILES} PARENT_SCOPE)
  endif()

  if(DEFINED DJINNI_PYCFFI_OUT_FILES)
    set(DJINNI_PYCFFI_GENERATION_COMMAND ${DJINNI_GENERATION_COMMAND})
    append_if_defined(DJINNI_PYCFFI_GENERATION_COMMAND "--pycffi-out" ${DJINNI_PYCFFI_OUT})

    resolve_djinni_outputs(COMMAND "${DJINNI_PYCFFI_GENERATION_COMMAND}" RESULT PYCFFI_OUT_FILES)

    add_custom_command(
      OUTPUT ${PYCFFI_OUT_FILES}
      DEPENDS ${DJINNI_INPUTS}
      COMMAND ${DJINNI_PYCFFI_GENERATION_COMMAND}
      COMMENT "Generating Djinni CFFI bindings from ${DJINNI_IDL}"
      VERBATIM
    )
    set(${DJINNI_PYCFFI_OUT_FILES} ${PYCFFI_OUT_FILES} PARENT_SCOPE)
  endif()

  if(DEFINED DJINNI_C_WRAPPER_OUT_FILES)
    set(DJINNI_C_WRAPPER_GENERATION_COMMAND ${DJINNI_GENERATION_COMMAND})
    append_if_defined(DJINNI_C_WRAPPER_GENERATION_COMMAND "--c-wrapper-out" ${DJINNI_C_WRAPPER_OUT})

    resolve_djinni_outputs(COMMAND "${DJINNI_C_WRAPPER_GENERATION_COMMAND}" RESULT C_WRAPPER_OUT_FILES)

    add_custom_command(
      OUTPUT ${C_WRAPPER_OUT_FILES}
      DEPENDS ${DJINNI_INPUTS}
      COMMAND ${DJINNI_C_WRAPPER_GENERATION_COMMAND}
      COMMENT "Generating Djinni C Wrapper bindings from ${DJINNI_IDL}"
      VERBATIM
    )
    set(${DJINNI_C_WRAPPER_OUT_FILES} ${C_WRAPPER_OUT_FILES} PARENT_SCOPE)
  endif()

  if(DEFINED DJINNI_CPPCLI_OUT_FILES)
    set(DJINNI_CPPCLI_GENERATION_COMMAND ${DJINNI_GENERATION_COMMAND})
    append_if_defined(DJINNI_CPPCLI_GENERATION_COMMAND "--cppcli-out" ${DJINNI_CPPCLI_OUT})

    resolve_djinni_outputs(COMMAND "${DJINNI_CPPCLI_GENERATION_COMMAND}" RESULT CPPCLI_OUT_FILES)

    add_custom_command(
      OUTPUT ${CPPCLI_OUT_FILES}
      DEPENDS ${DJINNI_INPUTS}
      COMMAND ${DJINNI_CPPCLI_GENERATION_COMMAND}
      COMMENT "Generating Djinni C++/CLI bindings from ${DJINNI_IDL}"
      VERBATIM
    )
    set(${DJINNI_CPPCLI_OUT_FILES} ${CPPCLI_OUT_FILES} PARENT_SCOPE)
  endif()

endfunction()

