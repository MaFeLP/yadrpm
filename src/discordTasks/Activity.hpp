//
// Created by max on 15.06.21.
//

#ifndef YADRPM_ACTIVITY_HPP
#define YADRPM_ACTIVITY_HPP
#include "../discord/discord.h"
#include "../Configuration.hpp"

namespace Tasks {
    struct Activity {
        Activity(Configuration *configuration, discord::Core *core);

        discord::Activity _activity{};
    private:
        Configuration * _configuration;
        discord::Core * _core;
    };
}

#endif //YADRPM_ACTIVITY_HPP
