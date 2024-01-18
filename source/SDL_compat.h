#pragma once


#include <SDL.h>
#include <SDL_image.h>
#include <SDL_mixer.h>
#include <SDL_ttf.h>

#if defined(__SWITCH__)
#include <switch.h>
#endif

#if defined(__3DS__)
#include <3ds.h>
#endif

#if defined(__WIIU__)
#include <coreinit/debug.h>
#include <whb/proc.h>
#endif


#ifdef _USE_SDL_LEGACY_VERSION


#ifdef _HAVE_SDL_GFX

#include <SDL_gfxPrimitives.h>
#endif

#define SDL_RENDERER_TYPE SDL_Surface*
#define SDL_TEXT_TYPE SDL_Surface*
#define SDL_COMPAT_TEXTURE_DESTROY SDL_FreeSurface


#else // !(_USE_SDL_LEGACY_VERSION)

#define SDL_RENDERER_TYPE SDL_Renderer*
#define SDL_TEXT_TYPE SDL_Texture*
#define SDL_SUPPORTS_TEXTURE
#define SDL_COMPAT_TEXTURE_DESTROY SDL_DestroyTexture
#define SDL_SUPPORTS_COLOR_MOD

#endif


SDL_RENDERER_TYPE SDL_compat_create_renderer(const char* title, const int width, const int height);

SDL_TEXT_TYPE
render_text(SDL_RENDERER_TYPE renderer, const char* text, TTF_Font* font, SDL_Color color, SDL_Rect* rect);

void SDL_compat_clear(SDL_RENDERER_TYPE renderer, SDL_Color color);

void SDL_compat_render_texture(
        SDL_RENDERER_TYPE renderer,
        SDL_TEXT_TYPE texture,
        SDL_Rect* src_rect,
        SDL_Rect* dest_rect
);

void SDL_compat_present(SDL_RENDERER_TYPE renderer);

void debug_print(const char* text);

void platform_init();

void platform_exit();

#define DEBUG_PRINTF(...)                                             \
    do {                                                              \
        char* internalBuffer = NULL;                                  \
        int toWrite = snprintf(NULL, 0, __VA_ARGS__) + 1;             \
        internalBuffer = (char*) malloc(toWrite * sizeof(char));      \
        if (internalBuffer == NULL) {                                 \
            exit(200);                                                \
        }                                                             \
        int written = snprintf(internalBuffer, toWrite, __VA_ARGS__); \
        if (written >= toWrite) {                                     \
            free(internalBuffer);                                     \
            exit(201);                                                \
        }                                                             \
        debug_print(internalBuffer);                                  \
        free(internalBuffer);                                         \
    } while (false)


#ifdef __3DS__
#define GENERAL_MAIN_LOOP aptMainLoop
#elif defined(__SWITCH__)
#define GENERAL_MAIN_LOOP appletMainLoop
#elif defined(__WIIU__)
#define GENERAL_MAIN_LOOP WHBProcIsRunning
#else
#error not implemented
#endif

#if defined(__3DS__) || defined(__SWITCH__)
#define ROMFS_DIR "romfs:/data/"
#elif defined(__WIIU__)
#define ROMFS_DIR "/content/data/"
#else
#error not implemented
#endif
