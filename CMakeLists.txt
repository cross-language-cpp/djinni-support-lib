cmake_minimum_required(VERSION 3.6.0)

if(DJINNI_WITH_OBJC)
  set(PROJECT_LANGUAGES OBJC OBJCXX)
elseif(DJINNI_WITH_CPPCLI)
  set(PROJECT_LANGUAGES CSharp)
endif()

project(djinni_support_lib CXX ${PROJECT_LANGUAGES})

include(GNUInstallDirs)

set(SRC_SHARED
  "djinni/djinni_common.hpp"
  "djinni/proxy_cache_interface.hpp"
  "djinni/proxy_cache_impl.hpp"
)

set(SRC_JNI
  "djinni/jni/djinni_support.hpp"
  "djinni/jni/Marshal.hpp"
  "djinni/jni/djinni_support.cpp"
  "djinni/jni/djinni_jni_main.hpp"
  "djinni/jni/djinni_jni_main.cpp"
)

set(SRC_OBJC
  "djinni/objc/DJICppWrapperCache+Private.h"
  "djinni/objc/DJIError.h"
  "djinni/objc/DJIMarshal+Private.h"
  "djinni/objc/DJIObjcWrapperCache+Private.h"
  "djinni/objc/DJIError.mm"
  "djinni/objc/DJIProxyCaches.mm"
)

set(SRC_C_WRAPPER
  "djinni/cwrapper/thread_local.cpp"
  "djinni/cwrapper/thread_local.hpp"
  "djinni/cwrapper/wrapper_marshal.cpp"
  "djinni/cwrapper/wrapper_marshal.h"
  "djinni/cwrapper/wrapper_marshal.hpp"
)

set(SRC_CPPCLI
  "djinni/cppcli/Assert.hpp"
  "djinni/cppcli/AutoPtr.hpp"
  "djinni/cppcli/Error.hpp"
  "djinni/cppcli/Error.cpp"
  "djinni/cppcli/Marshal.hpp"
  "djinni/cppcli/WrapperCache.hpp"
  "djinni/cppcli/WrapperCache.cpp"
)

# set `DJINNI_LIBRARY_TYPE` to `STATIC` or `SHARED` to define the type of library.
# If undefined, the type will be determined based on `BUILD_SHARED_LIBS`
add_library(djinni_support_lib ${DJINNI_LIBRARY_TYPE} ${SRC_SHARED})
add_library(djinni-support-lib::djinni-support-lib ALIAS djinni_support_lib)

source_group("" FILES ${SRC_SHARED})

set_target_properties(djinni_support_lib PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED true
  CXX_EXTENSIONS false
)

install(
  TARGETS djinni_support_lib
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
)

install(
  FILES ${SRC_SHARED}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/djinni/
)

# Objective-C support
option(DJINNI_WITH_OBJC "Include the Objective-C support code in Djinni support library." off)
if(DJINNI_WITH_OBJC)
  target_include_directories(djinni_support_lib PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/djinni/objc/>")
  target_sources(djinni_support_lib PRIVATE ${SRC_OBJC})
  source_group("objc" FILES ${SRC_OBJC})
  target_compile_options(djinni_support_lib PUBLIC "-fobjc-arc")

  install(
    FILES
      "djinni/objc/DJICppWrapperCache+Private.h"
      "djinni/objc/DJIError.h"
      "djinni/objc/DJIMarshal+Private.h"
      "djinni/objc/DJIObjcWrapperCache+Private.h"
    DESTINATION
      ${CMAKE_INSTALL_INCLUDEDIR}/djinni/objc
  )

  target_link_libraries(djinni_support_lib PUBLIC
    "-framework Foundation"
  )

endif()

target_include_directories(djinni_support_lib PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>")

# JNI support
option(DJINNI_WITH_JNI "Include the JNI support code in Djinni support library." off)
if(DJINNI_WITH_JNI)
  set_target_properties(djinni_support_lib PROPERTIES
    POSITION_INDEPENDENT_CODE ON)
  target_include_directories(djinni_support_lib PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/djinni/jni/>")
  target_sources(djinni_support_lib PRIVATE ${SRC_JNI})
  source_group("jni" FILES ${SRC_JNI})

  install(
    FILES
      "djinni/jni/djinni_support.hpp"
      "djinni/jni/Marshal.hpp"
      "djinni/jni/djinni_jni_main.hpp"
    DESTINATION
      ${CMAKE_INSTALL_INCLUDEDIR}/djinni/jni
    )

  # Do not use the host's jni.h on Android as it is provided automatically by the NDK
  if(NOT ANDROID)
    find_package(JNI REQUIRED QUIET)
    target_include_directories(djinni_support_lib PUBLIC "${JNI_INCLUDE_DIRS}")
  endif()
endif()

# Python support
option(DJINNI_WITH_PYTHON "Include the Python support code in Djinni support library." off)
if(DJINNI_WITH_PYTHON)
  target_include_directories(djinni_support_lib PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/djinni/cwrapper/>")
  target_sources(djinni_support_lib PRIVATE ${SRC_C_WRAPPER})
  source_group("cwrapper" FILES ${SRC_C_WRAPPER})

  install(
    FILES
      "djinni/cwrapper/wrapper_marshal.h"
    DESTINATION
      ${CMAKE_INSTALL_INCLUDEDIR}/djinni/cwrapper
    )
endif()

option(DJINNI_WITH_CPPCLI "Include the C++/CLI support code in Djinni support library." off)
if(DJINNI_WITH_CPPCLI)

  if(NOT MSVC)
    message(FATAL_ERROR "Enabling DJINNI_WITH_CPPCLI without MSVC is not supported")
  endif()

  target_include_directories(djinni_support_lib PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/support-lib/cppcli/>")
  target_sources(djinni_support_lib PRIVATE ${SRC_CPPCLI})
  source_group("cppcli" FILES ${SRC_CPPCLI})
  set_target_properties(djinni_support_lib PROPERTIES
    VS_DOTNET_REFERENCES "System;System.Core"
    COMMON_LANGUAGE_RUNTIME ""
  )

  install(
    FILES
      "djinni/cppcli/Assert.hpp"
      "djinni/cppcli/AutoPtr.hpp"
      "djinni/cppcli/Error.hpp"
      "djinni/cppcli/Marshal.hpp"
      "djinni/cppcli/WrapperCache.hpp"
    DESTINATION
      ${CMAKE_INSTALL_INCLUDEDIR}/djinni/cppcli
  )
endif()

if(NOT (DJINNI_WITH_OBJC OR DJINNI_WITH_JNI OR DJINNI_WITH_PYTHON OR DJINNI_WITH_CPPCLI))
  message(FATAL_ERROR "At least one of DJINNI_WITH_OBJC or DJINNI_WITH_JNI or DJINNI_WITH_PYTHON or DJINNI_WITH_CPPCLI must be enabled.")
endif()

option(DJINNI_BUILD_TESTING "Build tests" ON)

include(CTest)
if (BUILD_TESTING AND DJINNI_BUILD_TESTING)
  add_subdirectory(test-suite)
endif()
