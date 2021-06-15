//
// Created by max on 15.06.21.
//

#include <iostream>
#include "UserManager.hpp"

Tasks::UserManager::UserManager(discord::Core *core, discord::User* user) : _core(core), _gameUser(user) {
    core->UserManager().OnCurrentUserUpdate.Connect([&]() {
        _core->UserManager().GetCurrentUser(_gameUser);

        std::cout << "Current user updated: " << _gameUser->GetUsername() << "#"
                  << _gameUser->GetDiscriminator() << "\n";

        _core->UserManager().GetUser(130050050968518656,
                                          [](discord::Result result, discord::User const& user) {
                                              if (result == discord::Result::Ok) {
                                                  std::cout << "Get " << user.GetUsername() << "\n";
                                              }
                                              else {
                                                  std::cout << "Failed to get David!\n";
                                              }
                                          });

        discord::ImageHandle handle{};
        handle.SetId(_gameUser->GetId());
        handle.SetType(discord::ImageType::User);
        handle.SetSize(256);

        _core->ImageManager().Fetch(
                handle, true, [&](discord::Result res, discord::ImageHandle handle) {
                    if (res == discord::Result::Ok) {
                        discord::ImageDimensions dims{};
                        _core->ImageManager().GetDimensions(handle, &dims);
                        std::cout << "Fetched " << dims.GetWidth() << "x" << dims.GetHeight()
                                  << " avatar!\n";

                        std::vector<uint8_t> data;
                        data.reserve(dims.GetWidth() * dims.GetHeight() * 4);
                        uint8_t* d = data.data();
                        _core->ImageManager().GetData(handle, d, data.size());

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
}
