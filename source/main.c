/* Mini SDL Demo
 * featuring SDL2 + SDL2_mixer + SDL2_image + SDL2_ttf
 * on Nintendo Switch using libnx
 * on Nintendo 3DS using libctru
 *
 * Copyright 2018 carsten1ns
 *           2020 WinterMute
 *           2024 Totto16
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#include <time.h>
#include <unistd.h>

#include "SDL_compat.h"


#define SCREEN_W 1280
#define SCREEN_H 720


int rand_range(int min, int max) {
    return min + rand() / (RAND_MAX / (max - min + 1) + 1);
}

int main(int argc, char* argv[]) {
    (void) argc;
    (void) argv;

    int exit_requested = 0;
    int trail = 0;
    int wait = 25;

    SDL_Texture* switchlogo_tex = NULL;
    SDL_Texture* sdllogo_tex = NULL;
    SDL_Texture* helloworld_tex = NULL;

    SDL_Rect pos = { 0, 0, 0, 0 };
    SDL_Rect sdl_pos = { 0, 0, 0, 0 };
    Mix_Music* music = NULL;
    Mix_Chunk* sound[4] = { NULL };
    SDL_Event event;

    SDL_Color colors[] = {
        {128, 128, 128, 0}, // gray
        {255, 255, 255, 0}, // white
        {255,   0,   0, 0}, // red
        {  0, 255,   0, 0}, // green
        {  0,   0, 255, 0}, // blue
        {255, 255,   0, 0}, // brown
        {  0, 255, 255, 0}, // cyan
        {255,   0, 255, 0}, // purple
    };
    int col = 0;
    int snd = 0;

    srand(time(NULL));
    int vel_x = rand_range(1, 5);
    int vel_y = rand_range(1, 5);

    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_AUDIO) != 0) {
        DEBUG_PRINTF("SDL_Init error: %s\n", SDL_GetError());
        return 1;
    }

    if (Mix_Init(MIX_INIT_OGG) == 0) {
        DEBUG_PRINTF("SDL_Mix_Init error: %s\n", SDL_GetError());
        return 2;
    };

    if (IMG_Init(IMG_INIT_PNG) == 0) {
        DEBUG_PRINTF("SDL_IMG_Init error: %s\n", SDL_GetError());
        return 3;
    };

    if (TTF_Init() != 0) {
        DEBUG_PRINTF("SDL_TTF_Init error: %s\n", SDL_GetError());
        return 4;
    };

    platform_init();

    SDL_Window* window = SDL_CreateWindow(
            "sdl2+mixer+image+ttf demo", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, SCREEN_W, SCREEN_H,
            SDL_WINDOW_SHOWN
    );
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_SOFTWARE);

    SDL_Surface* sdllogo = NULL;
#ifndef NO_ROMFS_SUPPORT
    // load logos from file
    sdllogo = IMG_Load(ROMFS_DIR "sdl.png");
    if (!sdllogo) {
        DEBUG_PRINTF("Couldn't load sdllogo: %s\n", SDL_GetError());
    }
#endif

    sdl_pos.w = sdllogo->w;
    sdl_pos.h = sdllogo->h;


    sdllogo_tex = SDL_CreateTextureFromSurface(renderer, sdllogo);
    if (!sdllogo_tex) {
        DEBUG_PRINTF("Couldn't load sdllogo_tex: %s\n", SDL_GetError());
    }
    SDL_FreeSurface(sdllogo);


    SDL_Surface* switchlogo = NULL;
#ifndef NO_ROMFS_SUPPORT
    switchlogo = IMG_Load(ROMFS_DIR "switch.png");
    if (!switchlogo) {
        DEBUG_PRINTF("Couldn't load switchlogo: %s\n", SDL_GetError());
    }
#endif

    pos.x = SCREEN_W / 2 - switchlogo->w / 2;
    pos.y = SCREEN_H / 2 - switchlogo->h / 2;
    pos.w = switchlogo->w;
    pos.h = switchlogo->h;

    switchlogo_tex = SDL_CreateTextureFromSurface(renderer, switchlogo);
    if (!switchlogo_tex) {
        DEBUG_PRINTF("Couldn't load switchlogo_tex: %s\n", SDL_GetError());
    }
    SDL_FreeSurface(switchlogo);


    col = rand_range(0, 7);

    SDL_InitSubSystem(SDL_INIT_JOYSTICK);
    SDL_JoystickEventState(SDL_ENABLE);
    SDL_JoystickOpen(0);

    // load font from romfs
    TTF_Font* font = NULL;
#ifndef NO_ROMFS_SUPPORT
    font = TTF_OpenFont(ROMFS_DIR "LeroyLetteringLightBeta01.ttf", 36);
    if (!font) {
        DEBUG_PRINTF("Couldn't load font: %s\n", SDL_GetError());
    }
#endif

    SDL_Rect helloworld_rect = { 0, SCREEN_H - 36, 0, 0 };
    if (font) {
        // render text as texture

        SDL_Surface* helloworld_surface = NULL;

        helloworld_surface = TTF_RenderText_Solid(font, "Hello, world!", colors[1]);
        helloworld_tex = SDL_CreateTextureFromSurface(renderer, helloworld_surface);
        helloworld_rect.w = helloworld_surface->w;
        helloworld_rect.h = helloworld_surface->h;

        SDL_FreeSurface(helloworld_surface);

        if (!helloworld_tex) {
            DEBUG_PRINTF("Couldn't load helloworld_tex: %s\n", SDL_GetError());
        }

        // no need to keep the font loaded
        TTF_CloseFont(font);
    }


    Mix_AllocateChannels(2);
    Mix_OpenAudio(48000, MIX_DEFAULT_FORMAT, 2, 4096);

#ifndef NO_ROMFS_SUPPORT
    // load music and sounds from files
    music = Mix_LoadMUS(ROMFS_DIR "background.ogg");
    sound[0] = Mix_LoadWAV(ROMFS_DIR "pop1.wav");
    sound[1] = Mix_LoadWAV(ROMFS_DIR "pop2.wav");
    sound[2] = Mix_LoadWAV(ROMFS_DIR "pop3.wav");
    sound[3] = Mix_LoadWAV(ROMFS_DIR "pop4.wav");
#endif

    if (music) {
        Mix_PlayMusic(music, -1);
    }

    while (!exit_requested && GENERAL_MAIN_LOOP()) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                exit_requested = 1;
            }


            // use joystick
            //TODO:
            /* if (event.type == SDL_JOYBUTTONDOWN) {
                if (event.jbutton.button == JOY_UP) {
                    if (wait > 0) {
                        wait--;
                    }
                }
                if (event.jbutton.button == JOY_DOWN) {
                    if (wait < 100) {
                        wait++;
                    }
                }

                if (event.jbutton.button == JOY_PLUS) {
                    exit_requested = 1;
                }

                if (event.jbutton.button == JOY_B) {
                    trail = !trail;
                }
            }*/
        }

        // set position and bounce on the walls
        pos.y += vel_y;
        pos.x += vel_x;
        if (pos.x + pos.w > SCREEN_W) {
            pos.x = SCREEN_W - pos.w;
            vel_x = -rand_range(1, 5);
            col = rand_range(0, 4);
            snd = rand_range(0, 3);
            if (sound[snd]) {
                Mix_PlayChannel(-1, sound[snd], 0);
            }
        }
        if (pos.x < 0) {
            pos.x = 0;
            vel_x = rand_range(1, 5);
            col = rand_range(0, 4);
            snd = rand_range(0, 3);
            if (sound[snd]) {
                Mix_PlayChannel(-1, sound[snd], 0);
            }
        }
        if (pos.y + pos.h > SCREEN_H) {
            pos.y = SCREEN_H - pos.h;
            vel_y = -rand_range(1, 5);
            col = rand_range(0, 4);
            snd = rand_range(0, 3);
            if (sound[snd]) {
                Mix_PlayChannel(-1, sound[snd], 0);
            }
        }
        if (pos.y < 0) {
            pos.y = 0;
            vel_y = rand_range(1, 5);
            col = rand_range(0, 4);
            snd = rand_range(0, 3);
            if (sound[snd]) {
                Mix_PlayChannel(-1, sound[snd], 0);
            }
        }

        if (!trail) {
            SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0xFF);
        } else {
            SDL_SetRenderDrawColor(renderer, 0xEE, 0xEE, 0xEE, 0xAF);
        }

        SDL_RenderClear(renderer);

        // put logos on screen
        if (sdllogo_tex) {
            SDL_RenderCopy(renderer, sdllogo_tex, NULL, &sdl_pos);
        }

        if (switchlogo_tex) {
            SDL_SetTextureColorMod(switchlogo_tex, colors[col].r, colors[col].g, colors[col].b);
            SDL_RenderCopy(renderer, switchlogo_tex, NULL, &pos);
        }

        // put text on screen
        if (helloworld_tex) {
            SDL_RenderCopy(renderer, helloworld_tex, NULL, &helloworld_rect);
        }


        SDL_RenderPresent(renderer);
        SDL_Delay(wait);
    }

    // clean up your textures when you are done with them
    if (sdllogo_tex) {
        SDL_DestroyTexture(sdllogo_tex);
    }
    if (switchlogo_tex) {
        SDL_DestroyTexture(switchlogo_tex);
    }
    if (helloworld_tex) {
        SDL_DestroyTexture(helloworld_tex);
    }


    // stop sounds and free loaded data
    Mix_HaltChannel(-1);
    Mix_FreeMusic(music);
    for (snd = 0; snd < 4; snd++) {
        if (sound[snd]) {
            Mix_FreeChunk(sound[snd]);
        }
        { }
    }

    IMG_Quit();
    Mix_CloseAudio();
    TTF_Quit();
    Mix_Quit();
    SDL_Quit();

    platform_exit();
    return 0;
}
