.PHONY: all build test

all: build

clean:
	@cd build && \
	cmake --build . --target clean

config: export JAVA_HOME=$(shell /usr/libexec/java_home)
config:
	@mkdir -p build && cd build && \
	cmake \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
		-DDJINNI_WITH_JNI=1 \
		-DDJINNI_WITH_OBJC=1 \
		..

build: config
	@cd build && \
	cmake --build . --parallel

test: build
	@cd build/test-suite && \
	ctest

