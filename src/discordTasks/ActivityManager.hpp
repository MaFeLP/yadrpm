//
// Created by max on 15.06.21.
//

#ifndef YADRPM_ACTIVITYMANAGER_HPP
#define YADRPM_ACTIVITYMANAGER_HPP
#include "../discord/discord.h"

namespace Tasks {
    struct ActivityManager {
        explicit ActivityManager(discord::Core *core);

    private:
        discord::Core *_core;
    };
}

#endif //YADRPM_ACTIVITYMANAGER_HPP
