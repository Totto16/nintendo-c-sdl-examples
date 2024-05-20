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
export CXX="$COMPILER_BIN/$TOOL_PREFIX-g++"
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
c_ld = 'bfd'
cpp_ld = 'bfd'
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
c_std = 'gnu11'
cpp_std = 'c++20'
c_args = [$COMMON_FLAGS, $COMPILE_FLAGS]
cpp_args = [$COMMON_FLAGS, $COMPILE_FLAGS]
c_link_args = [$COMMON_FLAGS, $LINK_FLAGS]
cpp_link_args = [$COMMON_FLAGS, $LINK_FLAGS]


[properties]
pkg_config_libdir = '$PKG_CONFIG_PATH'
needs_exe_wrapper = true
library_dirs= ['$LIBWUT_LIB', '$PORTLIBS_LIB_WIIU','$PORTLIBS_LIB_PPC']

BUILD_WUHB    = false

APP_ROMFS='$ROMFS'

EOF

## options: "smart, complete_rebuild"
export COMPILE_TYPE="smart"

export BUILDTYPE="debug"

if [ "$#" -eq 0 ]; then
    # nothing
    echo "Using compile type '$COMPILE_TYPE'"
elif [ "$#" -eq 1 ]; then
    COMPILE_TYPE="$1"
elif [ "$#" -eq 2 ]; then
    COMPILE_TYPE="$1"
    BUILDTYPE="$2"
else
    echo "Too many arguments given, expected 1 or 2"
    exit 1
fi

if [ "$COMPILE_TYPE" == "smart" ]; then
    : # noop
elif [ "$COMPILE_TYPE" == "complete_rebuild" ]; then
    : # noop
else
    echo "Invalid COMPILE_TYPE, expected: 'smart' or 'complete_rebuild'"
    exit 1
fi

if [ ! -d "$ROMFS" ]; then

    mkdir -p "$ROMFS"

    cp -r assets "$ROMFS/"

fi

if [ "$COMPILE_TYPE" == "complete_rebuild" ] || [ ! -e "$BUILD_DIR" ]; then

    meson setup "$BUILD_DIR" \
        "--wipe" \
        --cross-file "$CROSS_FILE" \
        "-Dbuildtype=$BUILDTYPE" \
        -Ddefault_library=static

fi

meson compile -C "$BUILD_DIR"
