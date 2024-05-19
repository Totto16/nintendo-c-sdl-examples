# Nintendo C SDL Examples

This are examples for all nintendo platforms using SDL2

It uses [devkitPro](https://devkitpro.org/)'s [devkitARM](https://devkitpro.org/wiki/devkitARM) and [devkitA64](https://switchbrew.org/wiki/Setting_up_Development_Environment).

It uses meson and not Makefiles o CMake (and custom cross files, not the ones, that can be generated by the toolchains, but it's based on them)

It is based on examples in [switch-examples](https://github.com/switchbrew/switch-examples.git)

It is based on my meson work in [oopetris](https://github.com/mgerhold/oopetris)


## How to build

You need sdl portlibs for the platform and some other portlibs, than you can build it by running:
```bash
./platforms/build-<platform>.sh
```


## Status


| Platform | Compiles | Has ROMFS | Runs as expected |
| -------- | -------- | --------- | ---------------- |
| 3ds      | ✅        | ✅         | ✅                |
| gamecube | ✅        | ❌         | ❓                |
| wii      | ✅        | ❌         | ❓                |
| wiiu     | ✅        | ❌         | ❓                |
| switch   | ✅        | ✅         | ❓                |
