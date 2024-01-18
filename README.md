# Nintendo C SDL Examples

This are examples for all nintendo platforms using SDL (1.2 or 2)

It uses [devkitPro](https://devkitpro.org/)'s [devkitARM](https://devkitpro.org/wiki/devkitARM) and [devkitA64](https://switchbrew.org/wiki/Setting_up_Development_Environment).

It uses meson and not Makefiles.

It is based on examples in [switch-examples](https://github.com/switchbrew/switch-examples.git)

It is based on my meson work in [oopetris](https://github.com/mgerhold/oopetris)


## How to build

You need sdl portlibs for the platform and some other portlibs, than you can build it by running:
```bash
./platforms/build-<platform>.sh
```
