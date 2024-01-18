#pragma once


#include <SDL.h>
#include <SDL_image.h>
#include <SDL_mixer.h>
#include <SDL_ttf.h>


#ifdef _USE_SDL_LEGACY_VERSION


#ifdef _HAVE_SDL_GFX

#include <SDL_gfxPrimitives.h>
#endif

#define SDL_RENDERER_TYPE SDL_Surface*
#define SDL_TEXT_TYPE SDL_Surface*

#else // !(_USE_SDL_LEGACY_VERSION)

#define SDL_RENDERER_TYPE SDL_Renderer*
#define SDL_TEXT_TYPE SDL_Texture*


#endif


SDL_RENDERER_TYPE SDL_compat_create_renderer(const char* title, const int width, const int height);

SDL_TEXT_TYPE
render_text(SDL_RENDERER_TYPE renderer, const char* text, TTF_Font* font, SDL_Color color, SDL_Rect* rect);


#ifdef __3DS__
#define GENERAL_MAIN_LOOP aptMainLoop
#elif defined(__SWITCH__)
#define GENERAL_MAIN_LOOP appletMainLoop
#endif

#define ROMFS_DIR "romfs:/data/"
