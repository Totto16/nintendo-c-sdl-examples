project(
    'nintendo-c++-sdl-examples',
    'c',
    'cpp',
    meson_version: '>=0.60.0',
    default_options: [
        'buildtype=release',
        'optimization=3',
        'strip=true',
        'cpp_std=c++20',
        'c_std=c11',
        'b_ndebug=if-release',
    ],
    version: '1.0.0',
)


compile_args = []


deps = []
inc_dirs = []

if not meson.is_cross_build()
    error('This is only designed, to be a cross-build')
endif

sdl_name = 'sdl2'

if host_machine.system() == 'switch' or host_machine.system() == 'wiiu'
elif host_machine.system() == '3ds' or host_machine.system() == 'wii'
    sdl_name = 'sdl'
    compile_args += ['-D_USE_SDL_LEGACY_VERSION']
else
    error('Not supported host system: \'' + host_machine.system() + '\'')
endif


deps += dependency(
    sdl_name,
    sdl_name.to_upper(),
    allow_fallback: false,
    required: true,
    native: false,
)

deps += dependency(
    sdl_name + '_ttf',
    sdl_name.to_upper() + '_ttf',
    allow_fallback: false,
    required: true,
    native: false,
)

if sdl_name == 'sdl'
    deps += dependency(
        sdl_name + '_gfx',
        sdl_name.to_upper() + '_gfx',
        allow_fallback: false,
        required: true,
        native: false,
    )

    compile_args += ['-D_HAVE_SDL_GFX']
endif

deps += dependency(
    sdl_name + '_mixer',
    sdl_name.to_upper() + '_mixer',
    allow_fallback: false,
    required: true,
    native: false,
)

deps += dependency(
    sdl_name + '_image',
    sdl_name.to_upper() + '_image',
    allow_fallback: false,
    required: true,
    native: false,
)


add_project_arguments('-fno-rtti', '-fno-exceptions', language: 'cpp')

src_files = []

subdir('source')

exe_name = 'sdl_example'

if meson.is_cross_build() and host_machine.system() == 'switch'
    subdir('platforms/switch')
elif meson.is_cross_build() and host_machine.system() == 'wiiu'
    subdir('platforms/wiiu')
elif meson.is_cross_build() and host_machine.system() == '3ds'
    subdir('platforms/3ds')
elif meson.is_cross_build() and host_machine.system() == 'wii'
    subdir('platforms/wii')
else
    error('Not implemnted for host system: \'' + host_machine.system() + '\'')
endif
