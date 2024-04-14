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

#if defined(__WII__)
#include <debug.h>
#include <gccore.h>
#include <stdbool.h>
#include <wiiuse/wpad.h>
#endif


#if defined(__GAMECUBE__)
#include <debug.h>
#include <stdbool.h>
#endif

void debug_print(const char* text);

void platform_init();

void platform_exit();

#define DEBUG_TAG "<CUSTOM_DEBUG>: "

#define DEBUG_PRINTF(...)                                                       \
    do {                                                                        \
        char* internalBuffer = NULL;                                            \
        int toWrite = snprintf(NULL, 0, DEBUG_TAG __VA_ARGS__) + 1;             \
        internalBuffer = (char*) malloc(toWrite * sizeof(char));                \
        if (internalBuffer == NULL) {                                           \
            exit(200);                                                          \
        }                                                                       \
        int written = snprintf(internalBuffer, toWrite, DEBUG_TAG __VA_ARGS__); \
        if (written >= toWrite) {                                               \
            free(internalBuffer);                                               \
            exit(201);                                                          \
        }                                                                       \
        debug_print(internalBuffer);                                            \
        free(internalBuffer);                                                   \
    } while (false)


#ifdef __3DS__
#define GENERAL_MAIN_LOOP() aptMainLoop()
#elif defined(__SWITCH__)
#define GENERAL_MAIN_LOOP() appletMainLoop()
#elif defined(__WIIU__)
#define GENERAL_MAIN_LOOP() WHBProcIsRunning()
#elif defined(__WII__)
#define GENERAL_MAIN_LOOP() true
#elif defined(__GAMECUBE__)
#define GENERAL_MAIN_LOOP() true
#else
#error "not implemented"
#endif

#if defined(__3DS__) || defined(__SWITCH__)
#define ROMFS_DIR "romfs:/data/"
#elif defined(__WIIU__)
//TODO: test
//#define ROMFS_DIR "/content/data/"
#define NO_ROMFS_SUPPORT
#elif defined(__WII__)
#define NO_ROMFS_SUPPORT
#elif defined(__GAMECUBE__)
#define NO_ROMFS_SUPPORT
#else
#error "not implemented"
#endif
