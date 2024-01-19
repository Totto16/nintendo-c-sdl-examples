
#include "SDL_compat.h"


SDL_RENDERER_TYPE SDL_compat_create_renderer(const char* title, const int width, const int height) {
#ifdef _USE_SDL_LEGACY_VERSION

    // title, icon name
    SDL_WM_SetCaption(title, title);

    SDL_Surface* screen = SDL_SetVideoMode(width, height, 0, 0);

    return screen;

#else
    SDL_Window* window =
            SDL_CreateWindow(title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, SDL_WINDOW_SHOWN);
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_SOFTWARE);

    return renderer;
#endif
}

SDL_TEXT_TYPE
render_text(SDL_RENDERER_TYPE renderer, const char* text, TTF_Font* font, SDL_Color color, SDL_Rect* rect) {
#ifdef _USE_SDL_LEGACY_VERSION
    SDL_Surface* const textSurface = TTF_RenderText_Solid(font, text, color);
    if (!textSurface) {
        SDL_SetError("TTF_RenderText_Solid error: %s", SDL_GetError());
        return NULL;
    }

    int result = SDL_BlitSurface(textSurface, NULL, renderer, rect);
    if (result != 0) {
        SDL_SetError("SDL_BlitSurface error: %s", SDL_GetError());
        SDL_FreeSurface(textSurface);
        return NULL;
    }

    return textSurface;
#else

    SDL_Surface* surface;
    SDL_Texture* texture;

    surface = TTF_RenderText_Solid(font, text, color);
    texture = SDL_CreateTextureFromSurface(renderer, surface);
    rect->w = surface->w;
    rect->h = surface->h;

    SDL_FreeSurface(surface);

    return texture;

#endif
}


void SDL_compat_clear(SDL_RENDERER_TYPE renderer, SDL_Color color) {
#ifdef _USE_SDL_LEGACY_VERSION
    Uint32 clear_color = SDL_MapRGB(renderer->format, color.r, color.g, color.b);
    SDL_FillRect(renderer, NULL, clear_color);
#else
    SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
    SDL_RenderClear(renderer);

#endif
}

void SDL_compat_render_texture(
        SDL_RENDERER_TYPE renderer,
        SDL_TEXT_TYPE texture,
        SDL_Rect* src_rect,
        SDL_Rect* dest_rect
) {
#ifdef _USE_SDL_LEGACY_VERSION
    SDL_BlitSurface(texture, src_rect, renderer, dest_rect);
#else
    SDL_RenderCopy(renderer, texture, src_rect, dest_rect);
#endif
}

void SDL_compat_present(SDL_RENDERER_TYPE renderer) {
#ifdef _USE_SDL_LEGACY_VERSION
    SDL_UpdateRect(renderer, 0, 0, 0, 0);
    SDL_Flip(renderer);
#else
    SDL_RenderPresent(renderer);
#endif
}


void debug_print(const char* text) {
#ifdef __3DS__
    svcOutputDebugString(text, strlen(text));
#elif defined(__SWITCH__)
    svcOutputDebugString(text, strlen(text));
#elif defined(__WIIU__)
    OSReportWarn(text);
#elif defined(__wii__)
    //TODO
    (void) text;
#else
#error not implemented
#endif
}

void platform_init() {
#if defined(__3DS__) || defined(__SWITCH__)
    Result ret = romfsInit();
    if (R_FAILED(ret)) {
        DEBUG_PRINTF("romfsInit() failed: 0x%08x\n", (unsigned int) ret);
        exit(100);
    }
#elif defined(__WIIU__)
    WHBProcInit();
#elif defined(__wii__)
    //TODO
#else
#error not implemented
#endif
}

void platform_exit() {
#if defined(__3DS__) || defined(__SWITCH__)
    romfsExit();
#elif defined(__WIIU__)
    WHBProcShutdown();
#elif defined(__wii__)
    //TODO
#else
#error not implemented
#endif
}
