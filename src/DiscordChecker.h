//
// Created by max on 16.08.21.
//

#ifndef YADRPM_DISCORDCHECKER_H
#define YADRPM_DISCORDCHECKER_H
#include <string>

namespace discord {
#ifdef __linux__
    int getProcessId();
#elif _WINDOWS
    TCHAR getProcessName(DWORD);
#endif

    bool isRunning();
}


#endif //YADRPM_DISCORDCHECKER_H
