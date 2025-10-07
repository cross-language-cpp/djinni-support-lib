cmake -G "Ninja Multi-Config" -B build/old -S . --fresh \
 -DDJINNI_WITH_OBJC=ON -DDJINNI_WITH_JNI=ON -DDJINNI_WITH_CPPCLI=OFF \
 -DDJINNI_EXECUTABLE=$(pwd)/ztmp/old/djinni \
 -DCMAKE_OSX_SYSROOT=$(xcodebuild -version -sdk macosx Path)

