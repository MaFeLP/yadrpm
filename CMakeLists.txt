cmake_minimum_required(VERSION 3.19)
project(yadrpm)

set(CMAKE_CXX_STANDARD 14)

include_directories(src/discord)

add_executable(yadrpm
        src/discord/achievement_manager.cpp
        src/discord/achievement_manager.h
        src/discord/activity_manager.cpp
        src/discord/activity_manager.h
        src/discord/application_manager.cpp
        src/discord/application_manager.h
        src/discord/core.cpp
        src/discord/core.h
        src/discord/discord.h
        src/discord/event.h
        src/discord/ffi.h
        src/discord/image_manager.cpp
        src/discord/image_manager.h
        src/discord/lobby_manager.cpp
        src/discord/lobby_manager.h
        src/discord/network_manager.cpp
        src/discord/network_manager.h
        src/discord/overlay_manager.cpp
        src/discord/overlay_manager.h
        src/discord/relationship_manager.cpp
        src/discord/relationship_manager.h
        src/discord/storage_manager.cpp
        src/discord/storage_manager.h
        src/discord/store_manager.cpp
        src/discord/store_manager.h
        src/discord/types.cpp
        src/discord/types.h
        src/discord/user_manager.cpp
        src/discord/user_manager.h
        src/discord/voice_manager.cpp
        src/discord/voice_manager.h
        src/main.cpp)
