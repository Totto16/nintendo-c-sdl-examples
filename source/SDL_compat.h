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

#include <wiiuse/wpad.h>
#endif


#if defined(_OGC_)
#include <debug.h>
#include <gccore.h>
#include <ogc/system.h>
#include <stdbool.h>
#endif

#if defined(__WUT__) || defined(_OGC_)
#include <romfs-wiiu.h>


#define R_FAILED(x) ((x) != 0)
#define Result int


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
#elif defined(_OGC_)
#define GENERAL_MAIN_LOOP() true
#else
#error "not implemented"
#endif


#if defined(__3DS__) || defined(__SWITCH__) || defined(__WIIU__) || defined(__WII__) || defined(__GAMECUBE__)
#else
#error "not supported platform"
#endif


#define ROMFS_DIR "romfs:/data/"
