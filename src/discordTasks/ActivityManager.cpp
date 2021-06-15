//
// Created by max on 15.06.21.
//

#include <iostream>
#include "ActivityManager.hpp"

Tasks::ActivityManager::ActivityManager(discord::Core *core) : _core(core) {
    _core->ActivityManager().RegisterCommand("");
    //_core->ActivityManager().RegisterSteam(1234);

    _core->ActivityManager().OnActivityJoin.Connect(
            [](const char* secret) { std::cout << "Join " << secret << "\n"; });
    _core->ActivityManager().OnActivitySpectate.Connect(
            [](const char* secret) {
                std::cout << "Spectate " << secret << "\n";
                return discord::ActivityJoinRequestReply::Yes;
            });
    _core->ActivityManager().OnActivityJoinRequest.Connect([&](discord::User const& user) {
        std::cout << "Join Request " << user.GetUsername() << "\n";
        _core->ActivityManager().SendRequestReply(user.GetId(), discord::ActivityJoinRequestReply::Yes, [&](discord::Result){
            std::cout << "`-> User joined: " << user.GetUsername() << "\n";
        });
    });
    _core->ActivityManager().OnActivityInvite.Connect(
            [](discord::ActivityActionType, discord::User const& user, discord::Activity const&) {
                std::cout << "Invite " << user.GetUsername() << "\n";
                return 0;
            });
}
