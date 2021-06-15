//
// Created by max on 15.06.21.
//

#ifndef YADRPM_LOBBYMANAGER_HPP
#define YADRPM_LOBBYMANAGER_HPP


#include "../discord/core.h"

namespace Tasks {
    struct LobbyManager {
        LobbyManager(discord::Core *core);

    private:
        discord::Core *_core;
    };
}

#endif //YADRPM_LOBBYMANAGER_HPP
