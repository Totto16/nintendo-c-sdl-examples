#!/usr/bin/env bash

set -e

export DEVKITPRO=/opt/devkitpro
export ARCH_DEVKIT_FOLDER="$DEVKITPRO/devkitPPC"
export COMPILER_BIN="$ARCH_DEVKIT_FOLDER/bin"
export PATH="$DEVKITPRO/tools/bin:$COMPILER_BIN:$PATH"

export PORTLIBS_PATH="$DEVKITPRO/portlibs"
export LIBWUT=$DEVKITPRO/wut

export PORTLIBS_LIB=$PORTLIBS_PATH/wiiu/lib
export PORTLIBS_LIB_2=$PORTLIBS_PATH/ppc/lib
export LIBWUT_LIB=$LIBWUT/lib

export PKG_CONFIG_PATH="$PORTLIBS_LIB/pkgconfig/"
export PKG_CONFIG_PATH_2="$PORTLIBS_LIB_2/pkgconfig/"

export ROMFS="romfs"

export BUILD_DIR="build-wiiu"

export TOOL_PREFIX=powerpc-eabi

export BIN_DIR="$PORTLIBS_PATH/wiiu/bin"
export BIN_DIR_2="$PORTLIBS_PATH/ppc/bin"
export PKG_CONFIG_EXEC=$BIN_DIR/$TOOL_PREFIX-pkg-config
export CMAKE="$BIN_DIR/$TOOL_PREFIX-cmake"

export PATH="$BIN_DIR_2:$BIN_DIR:$PATH"

export CC="$COMPILER_BIN/$TOOL_PREFIX-gcc"
export CXX="$COMPILER_BIN/$TOOL_PREFIX-g"++
export AS="$COMPILER_BIN/$TOOL_PREFIX-as"
export AR="$COMPILER_BIN/$TOOL_PREFIX-gcc-ar"
export RANLIB="$COMPILER_BIN/$TOOL_PREFIX-gcc-ranlib"
export NM="$COMPILER_BIN/$TOOL_PREFIX-gcc-nm"
export OBJCOPY="$COMPILER_BIN/$TOOL_PREFIX-objcopy"
export STRIP="$COMPILER_BIN/$TOOL_PREFIX-strip"

export ARCH=ppc
export CPU_VERSION=ppc
export COMMON_FLAGS="'-D__WIIU__', '-D__WUT__', '-ffunction-sections', '-DESPRESSO','-mcpu=750','-meabi','-mhard-float'"

export COMPILE_FLAGS="'-isystem', '$LIBWUT/include'"

export LINK_FLAGS="'-L$PORTLIBS_LIB', '-L$PORTLIBS_LIB_2','-L$LIBWUT_LIB','-specs=$DEVKITPRO/wut/share/wut.specs'"

export CROSS_FILE="./platforms/crossbuild-wiiu.ini"

cat <<EOF >"$CROSS_FILE"
[host_machine]
system = 'wiiu'
cpu_family = '$ARCH'
cpu = '$CPU_VERSION'
endian = 'little'

[constants]
devkitpro = '$DEVKITPRO'

[binaries]
c = '$CC'
cpp = '$CXX'
ar      = '$AR'
as      = '$AS'
ranlib  = '$RANLIB'
strip   = '$STRIP'
objcopy = '$OBJCOPY'
nm = '$NM'
pkg-config = '$PKG_CONFIG_EXEC'
cmake='false' # cmake has many errors on the wiiu port
freetype-config='$BIN_DIR_2/freetype-config'
libpng16-config='$BIN_DIR_2/libpng16-config'
libpng-config='$BIN_DIR_2/libpng-config'
sdl2-config='$BIN_DIR/sdl2-config'

[built-in options]
c_std = 'c11'
cpp_std = 'c++20'
c_args = [$COMMON_FLAGS, $COMPILE_FLAGS]
cpp_args = [$COMMON_FLAGS, $COMPILE_FLAGS]
c_link_args = [$COMMON_FLAGS, $LINK_FLAGS]
cpp_link_args = [$COMMON_FLAGS, $LINK_FLAGS]


[properties]
pkg_config_libdir = '$PKG_CONFIG_PATH:$PKG_CONFIG_PATH_2'
needs_exe_wrapper = true
library_dirs= ['$LIBWUT_LIB', '$PORTLIBS_LIB','$PORTLIBS_LIB_2']

APP_NAME	= 'sdl_example'
APP_AUTHOR 	= 'Totto16'
APP_ROMFS='$ROMFS'

# optional
APP_SHORT_NAME	= ''


EOF

meson setup "$BUILD_DIR" \
    --cross-file "$CROSS_FILE" \
    -Ddefault_library=static

meson compile -C "$BUILD_DIR"
