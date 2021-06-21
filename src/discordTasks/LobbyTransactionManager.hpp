//
// Created by max on 15.06.21.
//

#ifndef YADRPM_LOBBYTRANSACTIONMANAGER_HPP
#define YADRPM_LOBBYTRANSACTIONMANAGER_HPP

#include "../discord/discord.h"

namespace Tasks {
    struct LobbyTransactionManager {
        discord::LobbyTransaction _lobby{};

        explicit LobbyTransactionManager(discord::Core *core);

    private:
        discord::Core* _core;
    };
}

#endif //YADRPM_LOBBYTRANSACTIONMANAGER_HPP
