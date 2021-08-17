//
// Created by max on 16.08.21.
//

#include "DiscordChecker.h"

#ifdef __linux__
#include <dirent.h>
#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include <cstdlib>
#elif _WIN32
#include <windows.h>
#include <tchar.h>
#include <iostream>
#include <tlhelp32.h>
#endif

#ifdef __linux__
using std::string;

int discord::getProcessId()
{
    string processName {"Discord"};

    int pid = -1;

    // Open the /proc directory
    DIR *dp = opendir("/proc");
    if (dp != nullptr)
    {
        // Enumerate all entries in directory until process found
        struct dirent *dirp;
        while (pid < 0 && (dirp = readdir(dp)))
        {
            // Skip non-numeric entries
            int id = atoi(dirp->d_name);
            if (id > 0)
            {
                // Read contents of virtual /proc/{pid}/cmdline file
                string cmdPath = string("/proc/") + dirp->d_name + "/cmdline";
                std::ifstream cmdFile(cmdPath.c_str());
                string cmdLine;
                getline(cmdFile, cmdLine);
                if (!cmdLine.empty())
                {
                    // Keep first cmdline item which contains the program path
                    size_t pos = cmdLine.find('\0');
                    if (pos != string::npos)
                        cmdLine = cmdLine.substr(0, pos);
                    // Keep program name only, removing the path
                    pos = cmdLine.rfind('/');
                    if (pos != string::npos)
                        cmdLine = cmdLine.substr(pos + 1);
                    // Compare against requested process name
                    if (processName == cmdLine)
                        pid = id;
                }
            }
        }
    }

    closedir(dp);

    return pid;
}

#elif _WIN32
// Source: https://stackoverflow.com/questions/13179410/check-whether-one-specific-process-is-running-on-windows-with-c
DWORD FindProcessId(char* processName)
{
    // strip path

    char* p = strrchr(processName, '\\');
    if(p)
        processName = p+1;

    PROCESSENTRY32 processInfo;
    processInfo.dwSize = sizeof(processInfo);

    HANDLE processesSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if ( processesSnapshot == INVALID_HANDLE_VALUE )
        return 0;

    Process32First(processesSnapshot, &processInfo);
    if ( !strcmp(processName, processInfo.szExeFile) )
    {
        CloseHandle(processesSnapshot);
        std::cout << "Found discord process! #1\n Process ID: " << processInfo.th32ProcessID << "\n";
        return processInfo.th32ProcessID;
    }

    while ( Process32Next(processesSnapshot, &processInfo) )
    {
        if ( !strcmp(processName, processInfo.szExeFile) )
        {
            CloseHandle(processesSnapshot);
            std::cout << "Found discord process! #2\n Process ID: " << processInfo.th32ProcessID << "\n";
            return processInfo.th32ProcessID;
        }
    }

    CloseHandle(processesSnapshot);
    std::cerr << "Discord process instance not found!\n";
    return 0;
}
#endif

bool discord::isRunning() {
#ifdef __linux__
    return discord::getProcessId() > 0;
#elif _WIN32
    char name[] = "Discord.exe";
    return FindProcessId(name) > 0;
#else
    return true;
#endif
}
