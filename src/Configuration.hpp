//
// Created by max on 13.06.21.
//

#ifndef YADRPM_CONFIGURATION_HPP
#define YADRPM_CONFIGURATION_HPP

#include <string>
#include <map>
#include <ostream>
#include "discord/discord.h"

struct PresenceImage {
    bool enabled = false;
    std::string image{};
    std::string text{};
};

struct PresenceButton {
    bool enabled = false;
    std::string link{"https://www.youtube.com/watch?v=dQw4w9WgXcQ"};
    std::string text{"Want some Rick Roll?"};
};

struct PresenceTimestamp {
    bool enabled = true;
    int64_t startTimestamp = 0;
    int64_t currentTimestamp = 0;

    int64_t updateTimestamp();
    PresenceTimestamp();
};

struct Presence {
    std::string name{"Custom Rich Presence"};
    discord::ActivityType activityType;
    std::string details{"Made by MaFeLP"};
    std::string state{"Get yours today at https://github.com/MaFeLP/yadrpm !"};
    PresenceImage bigImage{};
    PresenceImage smallImage{};
    PresenceButton button1{};
    PresenceButton button2{};
    PresenceTimestamp timestamp{};

    static discord::ActivityType getActivityType(std::string&);
};

struct Configuration {
    long clientID = 0L;
    bool colorEnabled = true;
    std::string configFile{};
    static Configuration loadFromFile(const std::string&);
    Presence presence{};

private:
    static std::map<std::string, std::string> loadInformationFromFile(const std::string &configFilePath);
};

#endif //YADRPM_CONFIGURATION_HPP
