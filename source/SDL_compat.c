
#include "SDL_compat.h"


void debug_print(const char* text) {
#ifdef __3DS__
    svcOutputDebugString(text, strlen(text));
#elif defined(__SWITCH__)
    svcOutputDebugString(text, strlen(text));
#elif defined(__WIIU__)
    OSReportVerbose(text);
#elif defined(__WII__)
    fprintf(stderr, text);
#elif defined(__GAMECUBE__)
    fprintf(stderr, text);
#else
#error "not implemented"
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
//nothing to do
#elif defined(__WII__)
//nothing to do
#elif defined(__GAMECUBE__)
//nothing to do
#else
#error "not implemented"
#endif
}

void platform_exit() {
#if defined(__3DS__) || defined(__SWITCH__)
    romfsExit();
#elif defined(__WIIU__)
//nothing to do
#elif defined(__WII__)
//nothing to do
#elif defined(__GAMECUBE__)
//nothing to do
#else
#error "not implemented"
#endif
}
