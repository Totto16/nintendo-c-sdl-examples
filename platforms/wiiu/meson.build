
# libraries

dependencies = [
    'freetype2',
    'harfbuzz',
    'ogg',
    'vorbis',
    'vorbisfile',
    'zlib',
]

dependencies_native = [
    'bz2',
    'modplug',
    'png16',
    'SDL2main',
    'wut',
]


foreach dep : dependencies
    deps += dependency(
        dep,
        required: true,
        allow_fallback: false,
        native: false,
    )
endforeach

library_dirs = meson.get_external_property('library_dirs', [''])
if library_dirs.length() == 0
    error('property \'library_dirs\' has to be set!')
endif

c = meson.get_compiler('c')
foreach dep : dependencies_native
    deps += c.find_library(
        dep,
        required: true,
        dirs: library_dirs,
    )
endforeach



## compilation

elf_file = build_target(
    exe_name + '.elf',
    src_files,
    include_directories: inc_dirs,
    dependencies: deps,
    override_options: {
        'warning_level': '3',
        'werror': true,
    },
    native: false,
    target_type: 'executable',
)


elf2rpl = find_program('elf2rpl')
# executable input elf file, output rpx file
rpx_file = custom_target(
    exe_name + '.rpx',
    command: [elf2rpl, elf_file.full_path(), exe_name + '.rpx'],
    depends: [elf_file],
    output: [exe_name + '.rpx'],
    build_by_default: true,
)

build_wuhb = ['true', 'True', '1', true].contains(
    meson.get_external_property('BUILD_WUHB', ''),
)

if build_wuhb

    WUHB_DEPS = [rpx_file]

    wuhbtool = find_program('wuhbtool')


    WUHB_FLAGS = [wuhbtool, exe_name + '.rpx', exe_name + '.wuhb','--name=' + app_name,'--short-name=' + APP_SHORT_NAME,'--author=' + APP_AUTHOR]

    fs = import('fs')

    APP_ICON = meson.get_external_property('APP_ICON', '')

    if APP_ICON != ''

        if not fs.is_absolute(APP_ICON)
            APP_ICON = meson.project_source_root() / APP_ICON
        endif


        if not fs.exists(APP_ICON)
            error('APP_ICON should exist, but doesn\'t: \'' + APP_ICON + '\'')
        endif
        WUHB_FLAGS += ['--icon=' + APP_ICON]
    endif

    # TODO: figure out, if this is equal to ROMFS or not
    APP_CONTENT = meson.get_external_property('APP_CONTENT', '')
    if APP_CONTENT != ''
        if not fs.is_absolute(APP_CONTENT)
            APP_CONTENT = meson.project_source_root() / APP_CONTENT
        endif

        if not fs.exists(APP_CONTENT)
            error('APP_CONTENT should exist, but doesn\'t: \'' + APP_CONTENT + '\'')
        endif

        WUHB_FLAGS += '--content=' + APP_CONTENT

    endif

    # wuhbtool <exe_name>.rpx <exe_name>.wuhb <WUHB_FLAGS>
    custom_target(
        exe_name + '.wuhb',
        command: WUHB_FLAGS,
        depends: WUHB_DEPS,
        output: [exe_name + '.wuhb'],
        build_by_default: true,
    )

endif

