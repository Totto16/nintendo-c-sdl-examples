#!/usr/bin/env bash

set -e

export DEVKITPRO=/opt/devkitpro
export ARCH_DEVKIT_FOLDER="$DEVKITPRO/devkitPPC"
export COMPILER_BIN="$ARCH_DEVKIT_FOLDER/bin"
export PATH="$DEVKITPRO/tools/bin:$COMPILER_BIN:$PATH"

export OGC_CONSOLE="gamecube"
export OGC_SUBDIR="cube"
export OGC_MACHINE="ogc"

export PORTLIBS_PATH="$DEVKITPRO/portlibs"
export LIBOGC=$DEVKITPRO/libogc

export PORTLIBS_LIB=$PORTLIBS_PATH/$OGC_CONSOLE/lib
export PORTLIBS_LIB_2=$PORTLIBS_PATH/ppc/lib
export LIBOGC_LIB="$LIBOGC/lib/$OGC_SUBDIR"

export PKG_CONFIG_PATH="$PORTLIBS_LIB/pkgconfig/"
export PKG_CONFIG_PATH_2="$PORTLIBS_LIB_2/pkgconfig/"

export ROMFS="romfs"

export BUILD_DIR="build-wii"

export TOOL_PREFIX=powerpc-eabi

export BIN_DIR="$PORTLIBS_PATH/gamecube/bin"
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
export CPU_VERSION=ppc750
export COMMON_FLAGS="'-D__GAMECUBE__', '-ffunction-sections', '-m${OGC_MACHINE}','-DGEKKO','-mcpu=750','-meabi','-mhard-float','-ffunction-sections','-fdata-sections'"

export COMPILE_FLAGS="'-isystem', '$LIBOGC/include'"

export LINK_FLAGS="'-L$PORTLIBS_LIB', '-L$PORTLIBS_LIB_2','-L$LIBOGC_LIB'"

export CROSS_FILE="./platforms/crossbuild-wii.ini"

cat <<EOF >"$CROSS_FILE"
[host_machine]
system = 'wii'
cpu_family = '$ARCH'
cpu = '$CPU_VERSION'
endian = 'big'

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
library_dirs= ['$LIBOGC_LIB', '$PORTLIBS_LIB','$PORTLIBS_LIB_2']

EOF

meson setup "$BUILD_DIR" \
    --cross-file "$CROSS_FILE" \
    -Ddefault_library=static

meson compile -C "$BUILD_DIR"
