project(
    'nintendo-c-sdl-examples',
    'c',
    meson_version: '>=1.3.0',
    default_options: {
        'buildtype': 'release',
        'optimization': '3',
        'strip': true,
        'c_std': 'c11',
        'b_ndebug': 'if-release',
    },
    version: '1.1.0',
)

app_author = 'Totto16'
app_name = 'sdl_example'
app_desc = 'SDL Example'

compile_args = []

deps = []
inc_dirs = []

if not meson.is_cross_build()
    error('This is only designed, to be a cross-build')
endif

if (
    not (
        host_machine.system() == 'switch'
        or host_machine.system() == 'wiiu'
        or host_machine.system() == '3ds'
        or host_machine.system() == 'wii'
        or host_machine.system() == 'gamecube'
    )
)
    error('Not supported host system: \'' + host_machine.system() + '\'')
endif

deps += dependency(
    'sdl2',
    'SDL2',
    allow_fallback: false,
    required: true,
    native: false,
)

deps += dependency(
    'sdl2_ttf',
    'SDL2_ttf',
    allow_fallback: false,
    required: true,
    native: false,
)

deps += dependency(
    'sdl2_mixer',
    'SDL2_mixer',
    allow_fallback: false,
    required: true,
    native: false,
)

deps += dependency(
    'sdl2_image',
    'SDL2_image',
    allow_fallback: false,
    required: true,
    native: false,
)

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
elif meson.is_cross_build() and host_machine.system() == 'gamecube'
    subdir('platforms/gamecube')
else
    error('Not implemented for host system: \'' + host_machine.system() + '\'')
endif
