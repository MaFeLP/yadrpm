//
// Created by max on 13.06.21.
//

#ifndef YADRPM_CONFIGURATION_HPP
#define YADRPM_CONFIGURATION_HPP

#include <string>
#include <map>

struct Configuration {
    long clientID;
    static Configuration loadFromFile(const std::string&);


private:
    static std::map<std::string, std::string> loadInformationFromFile(const std::string &configFilePath);
};

#endif //YADRPM_CONFIGURATION_HPP
