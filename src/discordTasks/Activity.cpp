//
// Created by max on 15.06.21.
//

#include <iostream>
#include "Activity.hpp"

Tasks::Activity::Activity(Configuration* configuration, discord::Core* core) : _configuration(configuration), _core(core) {
    _activity.SetName(_configuration->presence.name.c_str());
    _activity.SetDetails(_configuration->presence.details.c_str()); // first line
    _activity.SetState(_configuration->presence.state.c_str()); // second line
    if (_configuration->presence.smallImage.enabled) {
        _activity.GetAssets().SetSmallImage(_configuration->presence.smallImage.image.c_str());
        _activity.GetAssets().SetSmallText(_configuration->presence.smallImage.text.c_str());
    }
    if (_configuration->presence.bigImage.enabled) {
        _activity.GetAssets().SetLargeImage(_configuration->presence.bigImage.image.c_str());
        _activity.GetAssets().SetLargeText(_configuration->presence.bigImage.text.c_str());
    }
    if (_configuration->presence.timestamp.enabled) {
        _activity.GetTimestamps().SetStart(discord::Timestamp{_configuration->presence.timestamp.startTimestamp});
        _activity.GetTimestamps().SetEnd(discord::Timestamp{});
    }
    if (_configuration->presence.button1.enabled) {
        _activity.GetSecrets().SetJoin(_configuration->presence.button1.link.c_str());
    }
    if (_configuration->presence.button2.enabled) {
        _activity.GetSecrets().SetSpectate(_configuration->presence.button2.link.c_str());
    }
    _activity.SetType(_configuration->presence.activityType);

    _core->ActivityManager().UpdateActivity(_activity, [](discord::Result result) {
        if (result != discord::Result::Ok)
            std::cerr << "Failed updating the activity!\n";
    });
}
