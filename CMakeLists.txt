cmake_minimum_required(VERSION 3.6.0)

project(djinni_support_lib)

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

option(DJINNI_STATIC_LIB "Build Djinni support library as a static library instead of dynamic (the default)." off)
if(DJINNI_STATIC_LIB)
  add_library(djinni_support_lib STATIC ${SRC_SHARED})
else()
  add_library(djinni_support_lib SHARED ${SRC_SHARED})
endif()
source_group("" FILES ${SRC_SHARED})

set_target_properties(djinni_support_lib PROPERTIES
  CXX_STANDARD 14
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

  if (NOT DJINNI_STATIC_LIB)
    target_link_libraries(djinni_support_lib
      "-framework Foundation"
    )
  endif()

endif()

# JNI support
option(DJINNI_WITH_JNI "Include the JNI support code in Djinni support library." off)
option(DJINNI_JNI_WITH_MAIN "Include the default minimal JNI_OnLoad and JNI_OnUnload implementation in Djinni support library." on)
if(DJINNI_WITH_JNI)
  if(DJINNI_JNI_WITH_MAIN)
    list(APPEND SRC_JNI "djinni/jni/djinni_main.cpp")
  endif()
  target_include_directories(djinni_support_lib PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/djinni/jni/>")
  target_sources(djinni_support_lib PRIVATE ${SRC_JNI})
  source_group("jni" FILES ${SRC_JNI})

  install(
    FILES
    "djinni/jni/djinni_support.hpp"
    "djinni/jni/Marshal.hpp"
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


if(NOT (DJINNI_WITH_OBJC OR DJINNI_WITH_JNI OR DJINNI_WITH_PYTHON))
  message(FATAL_ERROR "At least one of DJINNI_WITH_OBJC or DJINNI_WITH_JNI or DJINNI_WITH_PYTHON must be enabled.")
endif()


include(CTest)
if (BUILD_TESTING)
  add_subdirectory(test-suite)
endif()
