#define _CRT_SECURE_NO_WARNINGS

#include <csignal>
#include <cstdlib>
#include <iostream>
#include <thread>
#include <vector>

#include "discord/discord.h"
#include "discordTasks/tasks.hpp"
#include "Configuration.hpp"

#if defined(_WIN32)
#pragma pack(push, 1)
struct BitmapImageHeader {
    uint32_t const structSize{sizeof(BitmapImageHeader)};
    int32_t width{0};
    int32_t height{0};
    uint16_t const planes{1};
    uint16_t const bpp{32};
    uint32_t const pad0{0};
    uint32_t const pad1{0};
    uint32_t const hres{2835};
    uint32_t const vres{2835};
    uint32_t const pad4{0};
    uint32_t const pad5{0};

    BitmapImageHeader& operator=(BitmapImageHeader const&) = delete;
};

struct BitmapFileHeader {
    uint8_t const magic0{'B'};
    uint8_t const magic1{'M'};
    uint32_t size{0};
    uint32_t const pad{0};
    uint32_t const offset{sizeof(BitmapFileHeader) + sizeof(BitmapImageHeader)};

    BitmapFileHeader& operator=(BitmapFileHeader const&) = delete;
};
#pragma pack(pop)
#endif

using std::string;
using std::cout;
using std::cerr;

struct DiscordState {
    discord::User currentUser;

    std::unique_ptr<discord::Core> core;
};

namespace {
volatile bool interrupted{false};
}

int main(const int argc, const char** argv) {
    Configuration globalConfiguration{};

    for (int itemIndex = 0; itemIndex <= argc; ++itemIndex) {
        if (argv[itemIndex] == nullptr)
            break;
        string current = argv[itemIndex];
        if (current == "--help") {
            cout << "";
            return 0;
        } else if (current.substr(0, 8) == string{"--color="}) {
            string colorBuilder{};
            bool isStart = true;
            for (char &item : current) {
                if (isStart && item == '=')
                    isStart = false;
                else if (!isStart)
                    colorBuilder.push_back(item);
            }
            if (colorBuilder == string{"true"}) {
                globalConfiguration.colorEnabled = true;
            } else if (colorBuilder == string{"false"}) {
                globalConfiguration.colorEnabled = false;
            } else {
                cerr << "Unrecognised argument for --color=: " << colorBuilder << "!\n";
                return 1;
            }
        } else if (current.substr(0, 9) == string{"--config="}) {
            string configBuilder{};
            bool isStart = true;
            for (char &item : current) {
                if (isStart && item == '=')
                    isStart = false;
                else if (!isStart)
                    configBuilder.push_back(item);
            }

            globalConfiguration = Configuration::loadFromFile(configBuilder);
        } else if (current.substr(0, 12) == string{"--client-id="}) {
            string idBuilder{};
            bool isStart = true;
            for (char &item : current) {
                if (isStart && item == '=')
                    isStart = false;
                else if (!isStart)
                    idBuilder.push_back(item);
            }
            try {
                globalConfiguration.clientID = std::stol(idBuilder);
            } catch (std::invalid_argument &e) {
                cerr << "Bad Client ID: " << idBuilder << " !\n";
                return 1;
            }
        }
    }

    cout << "Initialising the discord game SDK...\n"
         << "If you get an error and this program exits, maybe check if discord is started!\n";
    DiscordState state{};
    discord::Core* core{};
    auto result = discord::Core::Create(globalConfiguration.clientID, DiscordCreateFlags_Default, &core);
    state.core.reset(core);
    if (!state.core) {
        std::cerr << "Failed to instantiate discord core! (err " << static_cast<int>(result)
                  << ")\n";
        std::exit(-1);
    }

    cout << "Initialisation sequence done!\n"
         << "If the app crashes from now on, it has a different origin!\n";

    state.core->SetLogHook(
      discord::LogLevel::Debug, [](discord::LogLevel level, const char* message) {
          std::cerr << "Log(" << static_cast<uint32_t>(level) << "): " << message << "\n";
      });

    // Create the activity
    Tasks::Activity activity{&globalConfiguration, core};

    // Activity Manager
    Tasks::ActivityManager activityManager{core};

    // Lobby Manager
    Tasks::LobbyManager lobbyManager{core};

    // Lobby Transaction Manager
    Tasks::LobbyTransactionManager lobbyTransactionManager{core};

    // User Manager
    Tasks::UserManager userManager{core, &state.currentUser};

    // Relationship Manager
    Tasks::RelationShipManager relationShipManager{core, &state.currentUser};

    std::signal(SIGINT, [](int) { interrupted = true; });
    std::signal(SIGTERM, [](int) { interrupted = true; });

    do {
        state.core->RunCallbacks();

        std::this_thread::sleep_for(std::chrono::milliseconds(16));
    } while (!interrupted);

    cout << "Thanks for using yadrpm!\n"
         << "Ran for "
         << globalConfiguration.presence.timestamp.updateTimestamp() - globalConfiguration.presence.timestamp.startTimestamp
         << " seconds!"
         << "\n";

    return 0;
}
