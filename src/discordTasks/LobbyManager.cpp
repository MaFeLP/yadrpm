//
// Created by max on 15.06.21.
//

#include <iostream>
#include "LobbyManager.hpp"

Tasks::LobbyManager::LobbyManager(discord::Core *core) : _core(core) {
    _core->LobbyManager().OnLobbyUpdate.Connect(
            [](std::int64_t lobbyId) { std::cout << "Lobby update " << lobbyId << "\n"; });

    _core->LobbyManager().OnLobbyDelete.Connect(
            [](std::int64_t lobbyId, std::uint32_t reason) {
                std::cout << "Lobby delete " << lobbyId << " (reason: " << reason << ")\n";
            });

    _core->LobbyManager().OnMemberConnect.Connect(
            [](std::int64_t lobbyId, std::int64_t userId) {
                std::cout << "Lobby member connect " << lobbyId << " userId " << userId << "\n";
            });

    _core->LobbyManager().OnMemberUpdate.Connect(
            [](std::int64_t lobbyId, std::int64_t userId) {
                std::cout << "Lobby member update " << lobbyId << " userId " << userId << "\n";
            });

    _core->LobbyManager().OnMemberDisconnect.Connect(
            [](std::int64_t lobbyId, std::int64_t userId) {
                std::cout << "Lobby member disconnect " << lobbyId << " userId " << userId << "\n";
            });

    _core->LobbyManager().OnLobbyMessage.Connect([&](std::int64_t lobbyId,
                                                          std::int64_t userId,
                                                          std::uint8_t* payload,
                                                          std::uint32_t payloadLength) {
        std::vector<uint8_t> buffer{};
        buffer.resize(payloadLength);
        memcpy(buffer.data(), payload, payloadLength);
        std::cout << "Lobby message " << lobbyId << " from " << userId << " of length "
                  << payloadLength << " bytes.\n";

        char fourtyNinetySix[4096];
        _core->LobbyManager().GetLobbyMetadataValue(lobbyId, "foo", fourtyNinetySix);

        std::cout << "Metadata for key foo is " << fourtyNinetySix << "\n";
    });

    _core->LobbyManager().OnSpeaking.Connect(
            [&](std::int64_t, std::int64_t userId, bool speaking) {
                std::cout << "User " << userId << " is " << (speaking ? "" : "NOT ") << "speaking.\n";
            });
}
