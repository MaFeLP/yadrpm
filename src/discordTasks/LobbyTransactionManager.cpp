//
// Created by max on 15.06.21.
//

#include <iostream>
#include "LobbyTransactionManager.hpp"

Tasks::LobbyTransactionManager::LobbyTransactionManager(discord::Core *core) : _core(core) {
    _core->LobbyManager().GetLobbyCreateTransaction(&_lobby);
    _lobby.SetCapacity(2);
    _lobby.SetMetadata("foo", "bar");
    _lobby.SetMetadata("baz", "bat");
    _lobby.SetType(discord::LobbyType::Public);
    _core->LobbyManager().CreateLobby(
            _lobby, [&](discord::Result result, discord::Lobby const& lobby) {
                if (result == discord::Result::Ok) {
                    std::cout << "Created _lobby with secret " << lobby.GetSecret() << "\n";
#ifndef _WIN32
                    std::array<uint8_t, 234> data{};
                    _core->LobbyManager().SendLobbyMessage(
                            lobby.GetId(),
                            reinterpret_cast<uint8_t*>(data.data()),
                            data.size(),
                            [](discord::Result result) {
                                std::cout << "Sent message. Result: " << static_cast<int>(result) << "\n";
                            });
#endif
                }
                else {
                    std::cout << "Failed creating _lobby. (err " << static_cast<int>(result) << ")\n";
                }

                discord::LobbySearchQuery query{};
                _core->LobbyManager().GetSearchQuery(&query);
                query.Limit(1);
                _core->LobbyManager().Search(query, [&](discord::Result result) {
                    if (result == discord::Result::Ok) {
                        std::int32_t lobbyCount{};
                        _core->LobbyManager().LobbyCount(&lobbyCount);
                        std::cout << "Lobby search succeeded with " << lobbyCount << " lobbies.\n";
                        for (auto i = 0; i < lobbyCount; ++i) {
                            discord::LobbyId lobbyId{};
                            _core->LobbyManager().GetLobbyId(i, &lobbyId);
                            std::cout << "  " << lobbyId << "\n";
                        }
                    }
                    else {
                        std::cout << "Lobby search failed. (err " << static_cast<int>(result) << ")\n";
                    }
                });
            });
}
