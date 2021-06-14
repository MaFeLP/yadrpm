#define _CRT_SECURE_NO_WARNINGS

#include <csignal>
#include <cstdlib>
#include <iostream>
#include <thread>
#include <vector>

#include "discord/discord.h"
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
         << "If the app crashes from now on, it has a different origin!";

    state.core->SetLogHook(
      discord::LogLevel::Debug, [](discord::LogLevel level, const char* message) {
          std::cerr << "Log(" << static_cast<uint32_t>(level) << "): " << message << "\n";
      });

    discord::Activity activity{};
    activity.SetName(globalConfiguration.presence.name.c_str());
    activity.SetDetails(globalConfiguration.presence.details.c_str()); // first line
    activity.SetState(globalConfiguration.presence.state.c_str()); // second line
    if (globalConfiguration.presence.smallImage.enabled) {
        activity.GetAssets().SetSmallImage(globalConfiguration.presence.smallImage.image.c_str());
        activity.GetAssets().SetSmallText(globalConfiguration.presence.smallImage.text.c_str());
    }
    if (globalConfiguration.presence.bigImage.enabled) {
        activity.GetAssets().SetLargeImage(globalConfiguration.presence.bigImage.image.c_str());
        activity.GetAssets().SetLargeText(globalConfiguration.presence.bigImage.text.c_str());
    }
    if (globalConfiguration.presence.timestamp.enabled) {
        activity.GetTimestamps().SetStart(discord::Timestamp{globalConfiguration.presence.timestamp.startTimestamp});
        activity.GetTimestamps().SetEnd(discord::Timestamp{});
    }
    activity.SetType(globalConfiguration.presence.activityType);

    // User Manager
    /*
    core->UserManager().OnCurrentUserUpdate.Connect([&state]() {
        state.core->UserManager().GetCurrentUser(&state.currentUser);

        std::cout << "Current user updated: " << state.currentUser.GetUsername() << "#"
                  << state.currentUser.GetDiscriminator() << "\n";

        state.core->UserManager().GetUser(130050050968518656,
                                          [](discord::Result result, discord::User const& user) {
                                              if (result == discord::Result::Ok) {
                                                  std::cout << "Get " << user.GetUsername() << "\n";
                                              }
                                              else {
                                                  std::cout << "Failed to get David!\n";
                                              }
                                          });

        discord::ImageHandle handle{};
        handle.SetId(state.currentUser.GetId());
        handle.SetType(discord::ImageType::User);
        handle.SetSize(256);

        state.core->ImageManager().Fetch(
          handle, true, [&state](discord::Result res, discord::ImageHandle handle) {
              if (res == discord::Result::Ok) {
                  discord::ImageDimensions dims{};
                  state.core->ImageManager().GetDimensions(handle, &dims);
                  std::cout << "Fetched " << dims.GetWidth() << "x" << dims.GetHeight()
                            << " avatar!\n";

                  std::vector<uint8_t> data;
                  data.reserve(dims.GetWidth() * dims.GetHeight() * 4);
                  uint8_t* d = data.data();
                  state.core->ImageManager().GetData(handle, d, data.size());

#if defined(_WIN32)
                  auto fileSize =
                    data.size() + sizeof(BitmapImageHeader) + sizeof(BitmapFileHeader);

                  BitmapImageHeader imageHeader;
                  imageHeader.width = static_cast<int32_t>(dims.GetWidth());
                  imageHeader.height = static_cast<int32_t>(dims.GetHeight());

                  BitmapFileHeader fileHeader;
                  fileHeader.size = static_cast<uint32_t>(fileSize);

                  FILE* fp = fopen("avatar.bmp", "wb");
                  fwrite(&fileHeader, sizeof(BitmapFileHeader), 1, fp);
                  fwrite(&imageHeader, sizeof(BitmapImageHeader), 1, fp);

                  for (auto y = 0u; y < dims.GetHeight(); ++y) {
                      auto pixels = reinterpret_cast<uint32_t const*>(data.data());
                      auto invY = dims.GetHeight() - y - 1;
                      fwrite(
                        &pixels[invY * dims.GetWidth()], sizeof(uint32_t) * dims.GetWidth(), 1, fp);
                  }

                  fflush(fp);
                  fclose(fp);
#endif
              }
              else {
                  std::cout << "Failed fetching avatar. (err " << static_cast<int>(res) << ")\n";
              }
          });
    });

    */

    // Activity Manager
    /*
    state.core->ActivityManager().RegisterCommand("run/command/foo/bar/baz/here.exe");
    state.core->ActivityManager().RegisterSteam(123123321);

    state.core->ActivityManager().OnActivityJoin.Connect(
      [](const char* secret) { std::cout << "Join " << secret << "\n"; });
    state.core->ActivityManager().OnActivitySpectate.Connect(
      [](const char* secret) { std::cout << "Spectate " << secret << "\n"; });
    state.core->ActivityManager().OnActivityJoinRequest.Connect([](discord::User const& user) {
        std::cout << "Join Request " << user.GetUsername() << "\n";
    });
    state.core->ActivityManager().OnActivityInvite.Connect(
      [](discord::ActivityActionType, discord::User const& user, discord::Activity const&) {
          std::cout << "Invite " << user.GetUsername() << "\n";
      });
    */

    // Lobby Manager
    /*
    state.core->LobbyManager().OnLobbyUpdate.Connect(
      [](std::int64_t lobbyId) { std::cout << "Lobby update " << lobbyId << "\n"; });

    state.core->LobbyManager().OnLobbyDelete.Connect(
      [](std::int64_t lobbyId, std::uint32_t reason) {
          std::cout << "Lobby delete " << lobbyId << " (reason: " << reason << ")\n";
      });

    state.core->LobbyManager().OnMemberConnect.Connect(
      [](std::int64_t lobbyId, std::int64_t userId) {
          std::cout << "Lobby member connect " << lobbyId << " userId " << userId << "\n";
      });

    state.core->LobbyManager().OnMemberUpdate.Connect(
      [](std::int64_t lobbyId, std::int64_t userId) {
          std::cout << "Lobby member update " << lobbyId << " userId " << userId << "\n";
      });

    state.core->LobbyManager().OnMemberDisconnect.Connect(
      [](std::int64_t lobbyId, std::int64_t userId) {
          std::cout << "Lobby member disconnect " << lobbyId << " userId " << userId << "\n";
      });

    state.core->LobbyManager().OnLobbyMessage.Connect([&](std::int64_t lobbyId,
                                                          std::int64_t userId,
                                                          std::uint8_t* payload,
                                                          std::uint32_t payloadLength) {
        std::vector<uint8_t> buffer{};
        buffer.resize(payloadLength);
        memcpy(buffer.data(), payload, payloadLength);
        std::cout << "Lobby message " << lobbyId << " from " << userId << " of length "
                  << payloadLength << " bytes.\n";

        char fourtyNinetySix[4096];
        state.core->LobbyManager().GetLobbyMetadataValue(lobbyId, "foo", fourtyNinetySix);

        std::cout << "Metadata for key foo is " << fourtyNinetySix << "\n";
    });

    state.core->LobbyManager().OnSpeaking.Connect(
      [&](std::int64_t, std::int64_t userId, bool speaking) {
          std::cout << "User " << userId << " is " << (speaking ? "" : "NOT ") << "speaking.\n";
      });
    */

    // Lobby Transaction Manager
    /*
    discord::LobbyTransaction lobby{};
    state.core->LobbyManager().GetLobbyCreateTransaction(&lobby);
    lobby.SetCapacity(2);
    lobby.SetMetadata("foo", "bar");
    lobby.SetMetadata("baz", "bat");
    lobby.SetType(discord::LobbyType::Public);
    state.core->LobbyManager().CreateLobby(
      lobby, [&state](discord::Result result, discord::Lobby const& lobby) {
          if (result == discord::Result::Ok) {
              std::cout << "Created lobby with secret " << lobby.GetSecret() << "\n";
              std::array<uint8_t, 234> data{};
              state.core->LobbyManager().SendLobbyMessage(
                lobby.GetId(),
                reinterpret_cast<uint8_t*>(data.data()),
                data.size(),
                [](discord::Result result) {
                    std::cout << "Sent message. Result: " << static_cast<int>(result) << "\n";
                });
          }
          else {
              std::cout << "Failed creating lobby. (err " << static_cast<int>(result) << ")\n";
          }

          discord::LobbySearchQuery query{};
          state.core->LobbyManager().GetSearchQuery(&query);
          query.Limit(1);
          state.core->LobbyManager().Search(query, [&state](discord::Result result) {
              if (result == discord::Result::Ok) {
                  std::int32_t lobbyCount{};
                  state.core->LobbyManager().LobbyCount(&lobbyCount);
                  std::cout << "Lobby search succeeded with " << lobbyCount << " lobbies.\n";
                  for (auto i = 0; i < lobbyCount; ++i) {
                      discord::LobbyId lobbyId{};
                      state.core->LobbyManager().GetLobbyId(i, &lobbyId);
                      std::cout << "  " << lobbyId << "\n";
                  }
              }
              else {
                  std::cout << "Lobby search failed. (err " << static_cast<int>(result) << ")\n";
              }
          });
      });
    */

    // Relationship Manager
    /*
    state.core->RelationshipManager().OnRefresh.Connect([&]() {
        std::cout << "Relationships refreshed!\n";

        state.core->RelationshipManager().Filter(
          [](discord::Relationship const& relationship) -> bool {
              return relationship.GetType() == discord::RelationshipType::Friend;
          });

        std::int32_t friendCount{0};
        state.core->RelationshipManager().Count(&friendCount);

        state.core->RelationshipManager().Filter(
          [&](discord::Relationship const& relationship) -> bool {
              return relationship.GetType() == discord::RelationshipType::Friend &&
                relationship.GetUser().GetId() < state.currentUser.GetId();
          });

        std::int32_t filteredCount{0};
        state.core->RelationshipManager().Count(&filteredCount);

        discord::Relationship relationship{};
        for (auto i = 0; i < filteredCount; ++i) {
            state.core->RelationshipManager().GetAt(i, &relationship);
            std::cout << relationship.GetUser().GetId() << " "
                      << relationship.GetUser().GetUsername() << "#"
                      << relationship.GetUser().GetDiscriminator() << "\n";
        }
    });

    state.core->RelationshipManager().OnRelationshipUpdate.Connect(
      [](discord::Relationship const& relationship) {
          std::cout << "Relationship with " << relationship.GetUser().GetUsername()
                    << " updated!\n";
      });
    */

    std::signal(SIGINT, [](int) { interrupted = true; });
    std::signal(SIGTERM, [](int) { interrupted = true; });

    do {
        state.core->RunCallbacks();

        state.core->ActivityManager().UpdateActivity(activity, [](discord::Result result) {
            if (result != discord::Result::Ok)
                cerr << "Failed updating the activity!\n";
        });

        std::this_thread::sleep_for(std::chrono::milliseconds(16));
    } while (!interrupted);

    cout << "Thanks for using yadrpm!\n"
         << "Ran for "
         << globalConfiguration.presence.timestamp.updateTimestamp() - globalConfiguration.presence.timestamp.startTimestamp
         << " seconds!"
         << "\n";

    return 0;
}
