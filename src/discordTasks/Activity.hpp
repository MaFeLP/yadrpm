//
// Created by max on 15.06.21.
//

#ifndef YADRPM_ACTIVITY_HPP
#define YADRPM_ACTIVITY_HPP
#include "../discord/discord.h"
#include "../Configuration.hpp"

namespace Tasks {
    struct Activity {
        discord::Activity _activity{};

        explicit Activity(Configuration *);
    private:
        Configuration * _configuration;
    };
}

#endif //YADRPM_ACTIVITY_HPP
