
#include "SDL_compat.h"


void debug_print(const char* text) {
#ifdef __3DS__
    svcOutputDebugString(text, strlen(text));
#elif defined(__SWITCH__)
    svcOutputDebugString(text, strlen(text));
#elif defined(__WIIU__)
    OSReportWarn(text);
#elif defined(__WII__)
    //TODO
    (void) text;
#elif defined(__GAMECUBE__)
    //TODO
    (void) text;
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
    WHBProcInit();
#elif defined(__WII__)
    WPAD_Init();
    SDL_ShowCursor(SDL_DISABLE);
#elif defined(__GAMECUBE__)
    //TODO
#else
#error "not implemented"
#endif
}

void platform_exit() {
#if defined(__3DS__) || defined(__SWITCH__)
    romfsExit();
#elif defined(__WIIU__)
    WHBProcShutdown();
#elif defined(__WII__)
//nothing to do
#elif defined(__GAMECUBE__)
    //TODO
#else
#error "not implemented"
#endif
}
