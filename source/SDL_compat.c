
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
    //TODO
    return NULL;
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
