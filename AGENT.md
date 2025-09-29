# Djinni support lib refactoring instructions

This is the support lib for <https://djinni.xlcpp.dev>

Over time, language support has been added, and now they are a maintainance burden.
We want to go back to basic, that means, focus on Objective-C and Java (JNI) support.

There is a python interaface and a C# interface.
We can keep the plain c wrapper, called cwrapper, if is is C specific and does not have dependencies other than C/C++.

- [x] Clean up the build system and remove everything does does not belong to Objective-C and Java (JNI) or C support.
- [ ] Remove all code that does not belong to Objective-C and Java (JNI) or C support.
- [ ] Remove all tests that does not belong to Objective-C and Java (JNI) or C support.
- [ ] Clean up the documentation remove everything that does not belong to Objective-C and Java (JNI) or C support.

The project builds with cmake, every step we shall be able to run cmake and do the tests.
To make that happen, I need 2 generator versions.

Implementation shall happen step by step and interative.
No agent mode to go crazy, follow the plan.

## Clean up build system (step 1)

I have encapsulated the old and new CMake calls in 2 scripts in the working directory

- Old generator with support for c# and python (sh zconf-old.sh)
- New generator where support for c# and python was removed (sh zconf-new.sh)

Review the scripts, zconf-old.sh and zconf-new.sh to understand them, but do not change them

### Definition of done

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
