//
// Created by max on 15.06.21.
//

#include <iostream>
#include "RelationShipManager.hpp"

Tasks::RelationShipManager::RelationShipManager(discord::Core *core, discord::User* user) : _core(core), _gameUser(user) {
    _core->RelationshipManager().OnRefresh.Connect([&]() {
        std::cout << "Relationships refreshed!\n";

        _core->RelationshipManager().Filter(
                [](discord::Relationship const& relationship) -> bool {
                    return relationship.GetType() == discord::RelationshipType::Friend;
                });

        std::int32_t friendCount{0};
        _core->RelationshipManager().Count(&friendCount);

        _core->RelationshipManager().Filter(
                [&](discord::Relationship const& relationship) -> bool {
                    return relationship.GetType() == discord::RelationshipType::Friend &&
                           relationship.GetUser().GetId() < _gameUser->GetId();
                });

        std::int32_t filteredCount{0};
        _core->RelationshipManager().Count(&filteredCount);

        discord::Relationship relationship{};
        for (auto i = 0; i < filteredCount; ++i) {
            _core->RelationshipManager().GetAt(i, &relationship);
            std::cout << relationship.GetUser().GetId() << " "
                      << relationship.GetUser().GetUsername() << "#"
                      << relationship.GetUser().GetDiscriminator() << "\n";
        }
    });

    _core->RelationshipManager().OnRelationshipUpdate.Connect(
            [](discord::Relationship const& relationship) {
                std::cout << "Relationship with " << relationship.GetUser().GetUsername()
                          << " updated!\n";
            });
}
