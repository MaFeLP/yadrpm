//
// Created by max on 15.06.21.
//

#ifndef YADRPM_RELATIONSHIPMANAGER_HPP
#define YADRPM_RELATIONSHIPMANAGER_HPP

#include "../discord/discord.h"

namespace Tasks {
    struct RelationShipManager {
        RelationShipManager(discord::Core *core, discord::User *user);

    private:
        discord::User* _gameUser;
        discord::Core* _core;
    };
}

#endif //YADRPM_RELATIONSHIPMANAGER_HPP
