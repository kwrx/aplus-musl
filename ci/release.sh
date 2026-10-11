#!/bin/bash
set -e

ROOTDIR=$(pwd)
BUILDDIR=$(pwd)/build-musl
INSTALLDIR=$(pwd)/build-musl/release

TARGET=${1:-x86_64}
HOST=${2:-$(gcc -dumpmachine)}
TOOLCHAIN_VERSION=${3:-0.1.0}

cleanup() {
    echo "> Cleaning up build directories..."
    rm -rf $BUILDDIR
}

trap cleanup EXIT

mkdir -p $BUILDDIR
mkdir -p $BUILDDIR/toolchain
mkdir -p $BUILDDIR/release

pushd $BUILDDIR/toolchain
    if [ ! -f $TARGET-aplus-toolchain-nocxx-$HOST.tar.xz ]; then
        echo "> Downloading toolchain for $TARGET-aplus..."
        wget https://github.com/kwrx/aplus-toolchain/releases/download/$TOOLCHAIN_VERSION/$TARGET-aplus-toolchain-nocxx-$HOST.tar.xz
    fi
    tar xJf $TARGET-aplus-toolchain-nocxx-$HOST.tar.xz
popd

pushd $BUILDDIR

    export PATH="$PATH:$(pwd)/toolchain/bin"
    export CC=$TARGET-aplus-gcc
    export CC_FOR_BUILD=$CC

    echo "> Configuring musl for $TARGET-aplus..."
    ../configure --host=$TARGET-aplus --prefix= --disable-shared --enable-static

    echo "> Building musl for $TARGET-aplus..."
    make -j$CPUS CFLAGS="-O2"
    make -j$CPUS DESTDIR="$INSTALLDIR/$TARGET-aplus" install

    echo "> Fixing symlink for ld-musl-$TARGET.so.1..."
    if [ -L $INSTALLDIR/$TARGET-aplus/lib/ld-musl-$TARGET.so.1 ]; then
        rm $INSTALLDIR/$TARGET-aplus/lib/ld-musl-$TARGET.so.1
        ln -s ld-musl-$TARGET.so $INSTALLDIR/$TARGET-aplus/lib/ld-musl-$TARGET.so.1
    fi
    
popd



echo "> Creating release tarball for $TARGET-aplus..."
pushd $INSTALLDIR
    tar cJf $TARGET-aplus-musl.tar.xz *
    mv $TARGET-aplus-musl.tar.xz $ROOTDIR
popd

exit 0