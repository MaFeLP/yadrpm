cmake_minimum_required(VERSION 3.16)
project(yadrpm)
set(CMAKE_CXX_STANDARD 14)

file(GLOB DISCORD_SOURCES src/discord/*.cpp)

include_directories(yadrpm ${CMAKE_SOURCE_DIR}/src ${CMAKE_SOURCE_DIR})
link_directories(yadrpm ${CMAKE_SOURCE_DIR} ${CMAKE_SOURCE_DIR}/src)

add_executable(yadrpm
        ${DISCORD_SOURCES}
        src/main.cpp)

target_link_libraries(yadrpm discord_game_sdk)
