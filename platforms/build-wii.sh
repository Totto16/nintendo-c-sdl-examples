#!/usr/bin/env bash

set -e

export DEVKITPRO="/opt/devkitpro"
export ARCH_DEVKIT_FOLDER="$DEVKITPRO/devkitPPC"
export COMPILER_BIN="$ARCH_DEVKIT_FOLDER/bin"
export PATH="$DEVKITPRO/tools/bin:$COMPILER_BIN:$PATH"

export OGC_CONSOLE="wii"
export OGC_SUBDIR="wii"
export OGC_MACHINE="rvl"

export PORTLIBS_PATH="$DEVKITPRO/portlibs"
export LIBOGC="$DEVKITPRO/libogc"

export PORTLIBS_PATH_OGC="$PORTLIBS_PATH/$OGC_CONSOLE"
export PORTLIBS_PATH_PPC="$PORTLIBS_PATH/ppc"

export PORTLIBS_LIB_OGC="$PORTLIBS_PATH_OGC/lib"
export PORTLIBS_LIB_PPC="$PORTLIBS_PATH_PPC/lib"
export LIBOGC_LIB="$LIBOGC/lib/$OGC_SUBDIR"

export PKG_CONFIG_PATH_OGC="$PORTLIBS_LIB_OGC/pkgconfig/"
export PKG_CONFIG_PATH_PPC="$PORTLIBS_LIB_PPC/pkgconfig/"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH_OGC:$PKG_CONFIG_PATH_PPC"

export ROMFS="romfs"

export BUILD_DIR="build-wii"

export TOOL_PREFIX="powerpc-eabi"

export BIN_DIR_OGC="$PORTLIBS_PATH_OGC/bin"
export BIN_DIR_PPC="$PORTLIBS_LIB_PPC/bin"
export PKG_CONFIG_EXEC="$BIN_DIR_OGC/$TOOL_PREFIX-pkg-config"
export CMAKE="$BIN_DIR_OGC/$TOOL_PREFIX-cmake"

export PATH="$BIN_DIR_PPC:$BIN_DIR_OGC:$PATH"

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

export COMMON_FLAGS="'-m${OGC_MACHINE}','-mcpu=750','-meabi','-mhard-float','-ffunction-sections','-fdata-sections'"

export COMPILE_FLAGS="'-D__WII__','-D_OGC_','-DGEKKO','-isystem', '$LIBOGC/include', '-I$PORTLIBS_PATH_PPC/include', '-I$PORTLIBS_PATH_OGC/include'"

export LINK_FLAGS="'-L$LIBOGC/lib','-L$PORTLIBS_LIB_PPC','-L$PORTLIBS_LIB_OGC'"

export CROSS_FILE="./platforms/crossbuild-wii.ini"

cat <<EOF >"$CROSS_FILE"
[host_machine]
system = 'wii'
cpu_family = '$ARCH'
cpu = '$CPU_VERSION'
endian = '$ENDIANESS'

[target_machine]
system = 'wii'
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
cmake='$CMAKE' 
freetype-config='$BIN_DIR_PPC/freetype-config'
libpng16-config='$BIN_DIR_PPC/libpng16-config'
libpng-config='$BIN_DIR_PPC/libpng-config'
sdl2-config='$BIN_DIR_OGC/sdl2-config'

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
library_dirs= ['$LIBOGC_LIB', '$PORTLIBS_LIB_OGC','$PORTLIBS_LIB_PPC']

EOF

meson setup "$BUILD_DIR" \
    --cross-file "$CROSS_FILE" \
    -Ddefault_library=static

meson compile -C "$BUILD_DIR"
