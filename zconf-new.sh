cmake -G "Ninja Multi-Config" -B build/new -S . --fresh \
 -DDJINNI_WITH_OBJC=ON -DDJINNI_WITH_JNI=ON \
 -DDJINNI_EXECUTABLE=$(pwd)/../djinni-generator/target/bin/djinni \
 -DCMAKE_OSX_SYSROOT=/Applications/Xcode-26.0.1.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
