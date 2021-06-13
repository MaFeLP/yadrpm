//
// Created by max on 13.06.21.
//

#include "Configuration.hpp"
#include <fstream>
#include <string>
#include <iostream>
#include <map>

using std::string;

Configuration Configuration::loadFromFile(const std::string& configFilePath) {
    Configuration out{};

    auto configMap = loadInformationFromFile(configFilePath);

    try {
        out.clientID = std::stol(configMap["clientID"]);
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
        // If line is comment
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