//
// Created by max on 13.06.21.
//

#include "Configuration.hpp"
#include <fstream>
#include <string>
#include <iostream>
#include <map>
#include <chrono>

using std::string;

Configuration Configuration::loadFromFile(const std::string& configFilePath) {
    Configuration out{};

    auto configMap = loadInformationFromFile(configFilePath);

    try {
        out.colorEnabled = std::stol(configMap["color"]);
        out.clientID = std::stol(configMap["clientID"]);
        out.presence.name = configMap["presence.name"];
        out.presence.activityType = Presence::getActivityType(configMap["presence.type"]);
        try {
            out.presence.bigImage.enabled = configMap["presence.bigImage.enabled"] == string{"true"};
            out.presence.smallImage.enabled = configMap["presence.smallImage.enabled"] == string{"true"};
        } catch (std::exception& exception) {
            std::cout << "One or more images not enabled." << std::endl;
        }
        if (out.presence.bigImage.enabled) {
            out.presence.bigImage.image = configMap["presence.bigImage.image"];
            out.presence.bigImage.text = configMap["presence.bigImage.text"];
        }
        if (out.presence.smallImage.enabled) {
            out.presence.smallImage.image = configMap["presence.smallImage.image"];
            out.presence.smallImage.text = configMap["presence.smallImage.text"];
        }
        try {
            out.presence.button1.enabled = configMap["presence.button1.enabled"] == string{"true"};
            out.presence.button2.enabled = configMap["presence.button2.enabled"] == string{"true"};
        } catch (std::exception& exception) {
            std::cout << "One or more buttons not enabled." << std::endl;
        }
        if (out.presence.button1.enabled) {
            out.presence.button1.link = configMap["presence.button1.link"];
            out.presence.button1.text = configMap["presence.button1.text"];
        }
        if (out.presence.button2.enabled) {
            out.presence.button2.link = configMap["presence.button2.link"];
            out.presence.button2.text = configMap["presence.button2.text"];
        }
    } catch (std::exception& exception) {
        std::cerr << exception.what();
    }

    return out;
}

std::map<std::string, std::string> Configuration::loadInformationFromFile(const string &configFilePath) {
    std::fstream configFile;
    configFile.open(configFilePath.c_str());

    std::map<string , string> configMap{};

    if (!configFile.is_open()) {
        return configMap;
    }

    string currentLine;
    while (getline(configFile, currentLine)) {
        // If line is comment, skip it.
        try {
            if (currentLine.at(0) == '#' || (currentLine.at(0) == '/' && currentLine.at(1) == '/'))
                continue;
        } catch (std::exception& exception) {}

        // Parse the line
        string keyBuilder{};
        string valueBuilder{};
        bool isKey = true;
        for (char& c : currentLine) {
            if (isKey) {
                if (c == '=')
                    isKey = false;
                else
                    keyBuilder.push_back(c);
            } else {
                valueBuilder.push_back(c);
            }
        }

        if (!configMap.insert(std::make_pair(keyBuilder, valueBuilder)).second) {
            configMap[keyBuilder] = valueBuilder;
        }
    }
    if (configFile.is_open())
        configFile.close();

    return configMap;
}

discord::ActivityType Presence::getActivityType(string& activityType) {
    if (activityType == string{"playing"})
        return discord::ActivityType::Playing;
    if (activityType == string{"listening"})
        return discord::ActivityType::Listening;
    if (activityType == string{"streaming"})
        return discord::ActivityType::Streaming;
    if (activityType == string{"watching"})
        return discord::ActivityType::Watching;

    std::cerr << "ActivityType does not math to any known! Defaulting to playing..." << std::endl;

    return discord::ActivityType::Playing;
}

PresenceTimestamp::PresenceTimestamp() {
    updateTimestamp();
    startTimestamp = currentTimestamp;
}

int64_t PresenceTimestamp::updateTimestamp() {
    using namespace std::chrono;

    const auto time = system_clock::now();
    currentTimestamp = duration_cast<seconds>(time.time_since_epoch()).count();
    return currentTimestamp;
}
