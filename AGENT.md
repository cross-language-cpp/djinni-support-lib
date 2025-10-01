# Djinni support lib refactoring instructions

This is the support lib for <https://djinni.xlcpp.dev>

Over time, language support has been added, and now they are a maintainance burden.
We want to go back to basic, that means, focus on Objective-C and Java (JNI) support.

There is a python interaface and a C# interface.
We can keep the plain c wrapper, called cwrapper, if is is C specific and does not have dependencies other than C/C++.

- [x] Clean up the build system and remove everything does does not belong to Objective-C and Java (JNI) or C support.
- [x] Remove all code that does not belong to Objective-C and Java (JNI) or C support.
- [ ] Remove all tests that does not belong to Objective-C and Java (JNI) or C support.
- [ ] Clean up the documentation remove everything that does not belong to Objective-C and Java (JNI) or C support.

The project builds with cmake, every step we shall be able to run cmake and do the tests.
To make that happen, I need 2 generator versions.

Implementation shall happen step by step and interative.
No agent mode to go crazy, follow the plan.

## step 1

Clean up CMake build system

### Definition of done 1

To succeed, sh zconf-new.sh shall run without error, and a build of it must work!

In the new generator, the C wrapper has been disabled, maybe we bring the back.
If there are problems due to the C wrapper, we will disable them in this project for now.

## Step 2

Remove all code that does not belong to Objective-C and Java (JNI) or C support.

### Definition of done 2

To succeed, sh zconf-new.sh shall run without error, and a build of it must work!

In the new generator, the C wrapper has been disabled, maybe we bring the back.
If there are problems due to the C wrapper, we will disable them in this project for now.

## Step 3

Remove all test code that does not belong to Objective-C and Java (JNI) or C support.

### Definition of done 3

To succeed, sh zconf-new.sh shall run without error, and a build of it must work!

In the new generator, the C wrapper has been disabled, maybe we bring the back.
If there are problems due to the C wrapper, we will disable them in this project for now.

## General build instrucktions

### New version

    sh zconf-new.sh
    cmake --build build/new --config Debug
    (cd build/new && ctest -C Debug)

### Old version

    sh zconf-old.sh
    cmake --build build/old --config Debug
    (cd build/old && ctest -C Debug)
