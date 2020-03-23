#!/bin/bash

host=$1

mkdir -p build-musl
mkdir -p build-musl/toolchain
mkdir -p build-musl/release


exit_and_clean() {
    #rm -rf build-musl
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
    make -j2 DESTDIR="$(pwd)/toolchain/$host-aplus" install              || exit_and_clean 1

    # Fix crt0.o, libc.so
    ln -s crt1.o $(pwd)/toolchain/$host-aplus/lib/crt0.o
    rm $(pwd)/release/$host-aplus/lib/ld-musl-$host.so.1
    rm $(pwd)/toolchain/$host-aplus/lib/libc.so

    # Test
    echo "int main() {return 0;}" | $host-aplus-gcc -x c -               || exit_and_clean 1

    # Release
    make -j2 DESTDIR="$(pwd)/release/$host-aplus" install                || exit_and_clean 1

    # Fix crt0.o, libc.so
    ln -s crt1.o $(pwd)/release/$host-aplus/lib/crt0.o
    rm $(pwd)/release/$host-aplus/lib/ld-musl-$host.so.1
    ln -s /lib/ld-musl-$host.so $(pwd)/release/$host-aplus/lib/ld-musl-$host.so.1
    mv $(pwd)/release/$host-aplus/lib/libc.so $(pwd)/release/$host-aplus/lib/ld-musl-$host.so
    
popd



pushd build-musl/release
    tar -cJf $host-aplus-musl.tar.xz *    || exit_and_clean 1
    mv $host-aplus-musl.tar.xz ../..      || exit_and_clean 1
popd


exit_and_clean 0
