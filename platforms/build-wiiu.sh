#!/usr/bin/env bash

set -e

export DEVKITPRO="/opt/devkitpro"
export ARCH_DEVKIT_FOLDER="$DEVKITPRO/devkitPPC"
export COMPILER_BIN="$ARCH_DEVKIT_FOLDER/bin"
export PATH="$DEVKITPRO/tools/bin:$COMPILER_BIN:$PATH"

export PORTLIBS_PATH="$DEVKITPRO/portlibs"
export LIBWUT="$DEVKITPRO/wut"

export PORTLIBS_PATH_WIIU="$PORTLIBS_PATH/wiiu"
export PORTLIBS_PATH_PPC="$PORTLIBS_PATH/ppc"

export PORTLIBS_LIB_WIIU="$PORTLIBS_PATH_WIIU/lib"
export PORTLIBS_LIB_PPC="$PORTLIBS_PATH_PPC/lib"
export LIBWUT_LIB="$LIBWUT/lib"

export PKG_CONFIG_PATH_WIIU="$PORTLIBS_LIB_WIIU/pkgconfig/"
export PKG_CONFIG_PATH_PPC="$PORTLIBS_LIB_PPC/pkgconfig/"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH_WIIU:$PKG_CONFIG_PATH_PPC"

export ROMFS="romfs"

export BUILD_DIR="build-wiiu"

export TOOL_PREFIX="powerpc-eabi"

export BIN_DIR_WIIU="$PORTLIBS_PATH_WIIU/bin"
export BIN_DIR_PPC="$PORTLIBS_PATH_PPC/bin"
export PKG_CONFIG_EXEC="$BIN_DIR_WIIU/$TOOL_PREFIX-pkg-config"
export CMAKE="$BIN_DIR_WIIU/$TOOL_PREFIX-cmake"

export PATH="$BIN_DIR_WIIU:$BIN_DIR_PPC:$PATH"

export CC="$COMPILER_BIN/$TOOL_PREFIX-gcc"
export CXX="$COMPILER_BIN/$TOOL_PREFIX-g"++
export AS="$COMPILER_BIN/$TOOL_PREFIX-as"
export AR="$COMPILER_BIN/$TOOL_PREFIX-gcc-ar"
export RANLIB="$COMPILER_BIN/$TOOL_PREFIX-gcc-ranlib"
export NM="$COMPILER_BIN/$TOOL_PREFIX-gcc-nm"
export OBJCOPY="$COMPILER_BIN/$TOOL_PREFIX-objcopy"
export STRIP="$COMPILER_BIN/$TOOL_PREFIX-strip"

export ARCH="ppc"
export CPU_VERSION="ppc750"
export ENDIANESS="big"

export COMMON_FLAGS="'-mcpu=750','-meabi','-mhard-float','-ffunction-sections','-fdata-sections'"

export COMPILE_FLAGS="'-DESPRESSO','-D__WIIU__','-D__WUT__','-isystem', '$LIBWUT/include', '-I$PORTLIBS_PATH_WIIU/include', '-I$PORTLIBS_PATH_PPC/include'"

export LINK_FLAGS="'-L$PORTLIBS_LIB_WIIU', '-L$PORTLIBS_LIB_PPC','-L$LIBWUT_LIB','-specs=$DEVKITPRO/wut/share/wut.specs'"

export CROSS_FILE="./platforms/crossbuild-wiiu.ini"

cat <<EOF >"$CROSS_FILE"
[host_machine]
system = 'wiiu'
cpu_family = '$ARCH'
cpu = '$CPU_VERSION'
endian = '$ENDIANESS'

[target_machine]
system = 'wiiu'
cpu_family = '$ARCH'
cpu = '$CPU_VERSION'
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
cmake='false' # cmake has many errors on the wiiu port
freetype-config='$BIN_DIR_PPC/freetype-config'
libpng16-config='$BIN_DIR_PPC/libpng16-config'
libpng-config='$BIN_DIR_PPC/libpng-config'
sdl2-config='$BIN_DIR_WIIU/sdl2-config'

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
library_dirs= ['$LIBWUT_LIB', '$PORTLIBS_LIB_WIIU','$PORTLIBS_LIB_PPC']

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
