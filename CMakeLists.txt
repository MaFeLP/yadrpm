cmake_minimum_required(VERSION 3.16)
project(yadrpm)
set(CMAKE_CXX_STANDARD 14)

file(GLOB DISCORD_SOURCES src/discord/*.cpp)
file(GLOB DISCORD_TASKS src/discordTasks/*.cpp)

include_directories(yadrpm ${CMAKE_SOURCE_DIR}/src ${CMAKE_SOURCE_DIR})
link_directories(yadrpm ${CMAKE_SOURCE_DIR} ${CMAKE_SOURCE_DIR}/src)

add_executable(yadrpm
        ${DISCORD_SOURCES}
        ${DISCORD_TASKS}
        src/Configuration.cpp
        src/Configuration.hpp
        src/main.cpp src/DiscordChecker.cpp src/DiscordChecker.h)

target_link_libraries(yadrpm discord_game_sdk)
