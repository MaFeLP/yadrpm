//
// Created by max on 15.06.21.
//

#ifndef YADRPM_USERMANAGER_HPP
#define YADRPM_USERMANAGER_HPP

#include "../discord/discord.h"

namespace Tasks {
    struct UserManager {
        UserManager(discord::Core *core, discord::User* user);

    private:
        discord::User* _gameUser;
        discord::Core* _core;
    };
}

#endif //YADRPM_USERMANAGER_HPP
