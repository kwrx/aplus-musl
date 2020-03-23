#!/bin/bash

host=$1

mkdir -p build-musl
mkdir -p build-musl/toolchain
mkdir -p build-musl/release


exit_and_clean() {
    rm -rf build-musl
    exit $1
}


pushd build-musl/toolchain
    wget https://github.com/kwrx/aplus-toolchain/releases/latest/download/$host-aplus-toolchain-nocxx.tar.xz || exit_and_clean 1
    tar -xJf $host-aplus-toolchain-nocxx.tar.xz || exit_and_clean 1
popd

pushd build-musl

    export PATH="$PATH:$(pwd)/toolchain/bin"
    export CC=$host-aplus-gcc
    export CC_FOR_BUILD=$CC

    
    ../configure --host=$host-aplus --prefix=                            || exit_and_clean 1

    # Build
    make -j2 CFLAGS="-g -O2"                                             || exit_and_clean 1
    make -j2 DESTDIR="$(pwd)/toolchain" install                          || exit_and_clean 1

    # Test
    echo "int main() {return 0;}" | $host-aplus-gcc -x c -               || exit_and_clean 1

    # Release
    make -j2 DESTDIR="$(pwd)/release" install                            || exit_and_clean 1
    
popd



pushd build-musl/release
    tar -cJf $host-aplus-musl.tar.xz *    || exit_and_clean 1
    mv $host-aplus-musl.tar.xz ../..      || exit_and_clean 1
popd


exit_and_clean 0
