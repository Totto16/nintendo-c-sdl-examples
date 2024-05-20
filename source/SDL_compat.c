
#include "SDL_compat.h"


void debug_print(const char* text) {
#ifdef __3DS__
    svcOutputDebugString(text, strlen(text));
#elif defined(__SWITCH__)
    svcOutputDebugString(text, strlen(text));
#elif defined(__WIIU__)
    OSReportVerbose(text);
#elif defined(_OGC_)
    SYS_Report(text);
#else
#error "not implemented"
#endif
}

void platform_init() {
    Result ret = romfsInit();
    if (R_FAILED(ret)) {
        DEBUG_PRINTF("romfsInit() failed: 0x%08x\n", (unsigned int) ret);
        exit(100);
    }
}

void platform_exit() {
    romfsExit();
}
