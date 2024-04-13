#!/usr/bin/env bash

set -e

export DEVKITPRO="/opt/devkitpro"
export ARCH_DEVKIT_FOLDER="$DEVKITPRO/devkitARM"
export COMPILER_BIN="$ARCH_DEVKIT_FOLDER/bin"
export ARCH_DEVKIT_LIB="$ARCH_DEVKIT_FOLDER/lib"
export PATH="$DEVKITPRO/tools/bin:$COMPILER_BIN:$PATH"

export PORTLIBS_PATH="$DEVKITPRO/portlibs"
export PORTLIBS_PATH_3DS="$PORTLIBS_PATH/3ds"
export LIBCTRU="$DEVKITPRO/libctru"

export PORTLIBS_LIB="$PORTLIBS_PATH_3DS/lib"
export LIBCTRU_LIB="$LIBCTRU/lib"

export PKG_CONFIG_PATH="$PORTLIBS_LIB/pkgconfig/"

export ROMFS="romfs"

export BUILD_DIR="build-3ds"

export TOOL_PREFIX="arm-none-eabi"

export BIN_DIR="$PORTLIBS_PATH_3DS/bin"
export PKG_CONFIG_EXEC="$BIN_DIR/$TOOL_PREFIX-pkg-config"
export CMAKE="$BIN_DIR/$TOOL_PREFIX-cmake"

export PATH="$BIN_DIR:$PATH"

export CC="$COMPILER_BIN/$TOOL_PREFIX-gcc"
export CXX="$COMPILER_BIN/$TOOL_PREFIX-g"++
export AS="$COMPILER_BIN/$TOOL_PREFIX-as"
export AR="$COMPILER_BIN/$TOOL_PREFIX-gcc-ar"
export RANLIB="$COMPILER_BIN/$TOOL_PREFIX-gcc-ranlib"
export NM="$COMPILER_BIN/$TOOL_PREFIX-gcc-nm"
export OBJCOPY="$COMPILER_BIN/$TOOL_PREFIX-objcopy"
export STRIP="$COMPILER_BIN/$TOOL_PREFIX-strip"

export ARCH="arm"
export ARM_VERSION="arm11mpcore"
export ENDIANESS="little"

export COMMON_FLAGS="'-march=armv6k','-mtune=mpcore','-mfloat-abi=hard', '-mtp=soft','-mword-relocations', '-ffunction-sections', '-fdata-sections'"

export COMPILE_FLAGS="'-D_3DS','-D__3DS__', '-isystem', '$LIBCTRU/include', '-I$PORTLIBS_PATH_3DS/include'"

export LINK_FLAGS="'-L$PORTLIBS_LIB','-L$LIBCTRU_LIB','-fPIE','-specs=$ARCH_DEVKIT_FOLDER/$TOOL_PREFIX/lib/3dsx.specs'"

export CROSS_FILE="./platforms/crossbuild-3ds.ini"

cat <<EOF >"$CROSS_FILE"
[host_machine]
system = '3ds'
cpu_family = '$ARCH'
cpu = '$ARM_VERSION'
endian = '$ENDIANESS'

[target_machine]
system = '3ds'
cpu_family = '$ARCH'
cpu = '$ARM_VERSION'
endian = '$ENDIANESS'

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
cmake='$CMAKE'
freetype-config='$BIN_DIR/freetype-config'
libpng16-config='$BIN_DIR/libpng16-config'
libpng-config='$BIN_DIR/libpng-config'
sdl-config='$BIN_DIR/sdl-config'

[built-in options]
c_std = 'c11'
cpp_std = 'c++20'
c_args = [$COMMON_FLAGS, $COMPILE_FLAGS]
cpp_args = [$COMMON_FLAGS, $COMPILE_FLAGS]
c_link_args = [$COMMON_FLAGS, $LINK_FLAGS]
cpp_link_args = [$COMMON_FLAGS, $LINK_FLAGS]


[properties]
pkg_config_libdir = '$PKG_CONFIG_PATH'
needs_exe_wrapper = true
library_dirs= ['$LIBCTRU_LIB', '$PORTLIBS_LIB']
libctru='$LIBCTRU'

APP_NAME	= 'sdl_example'
APP_AUTHOR 	= 'Totto16'
APP_DESC = 'SDL Example'
APP_ROMFS='$ROMFS'

USE_SMDH    = true

EOF

meson setup "$BUILD_DIR" \
    --cross-file "$CROSS_FILE" \
    -Ddefault_library=static

meson compile -C "$BUILD_DIR"
