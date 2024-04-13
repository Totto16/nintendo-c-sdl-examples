
# libraries

gamecube_dependencies = [
    'freetype2',
    'harfbuzz',
    'ogg',
    'vorbis',
    'vorbisfile',
    'zlib',
]

gamecube_dependencies_native = [
    'bz2',
    'modplug',
    'ogc',
    'png16',
]


foreach dep : gamecube_dependencies
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
foreach dep : gamecube_dependencies_native
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
    c_args: compile_args,
    cpp_args: compile_args,
    override_options: [
        'warning_level=3',
        'werror=true',
    ],
    native: false,
    target_type: 'executable',
)

DOL_DEPS = [elf_file]


elf2dol = find_program('elf2dol')

# elf2dol <exe_name>.elf <exe_name>.dol 
custom_target(
    exe_name + '.dol',
    command: [elf2dol, elf_file.full_path(), exe_name + '.dol'],
    depends: DOL_DEPS,
    output: [exe_name + '.dol'],
    build_by_default: true,
)
