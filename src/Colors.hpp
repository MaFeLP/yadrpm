//
// Created by max on 06.04.21.
//

#ifndef MATHEMAXC_COLORS_HPP
#define MATHEMAXC_COLORS_HPP

namespace Colors {
    namespace Resets {
        // Resets the colors to the terminal defaults.
        constexpr static auto ALL = "\033[0;0m";
        constexpr static auto BOLD = "\033[0;1m";
        constexpr static auto DIM = "\033[0;2m";
        constexpr static auto UNDERLINED = "\033[0;4m";
        constexpr static auto BLINK = "\033[0;5m";
        constexpr static auto REVERSE = "\033[0;7m";
        constexpr static auto HIDDEN = "\033[0;8m";
    }

    namespace TextColors {
        // normal text colors
        constexpr static auto BLACK = "\033[0;30m";
        constexpr static auto RED = "\033[0;31m";
        constexpr static auto GREEN = "\033[0;32m";
        constexpr static auto YELLOW = "\033[0;33m";
        constexpr static auto BLUE = "\033[0;34m";
        constexpr static auto MAGENTA = "\033[0;35m";
        constexpr static auto CYAN = "\033[0;36m";
        constexpr static auto LIGHT_GRAY = "\033[0;37m";
        constexpr static auto DARK_GRAY = "\033[0;90m";
        constexpr static auto LIGHT_RED = "\033[0;91m";
        constexpr static auto LIGHT_GREEN = "\033[0;92m";
        constexpr static auto LIGHT_YELLOW = "\033[0;93m";
        constexpr static auto LIGHT_BLUE = "\033[0;94m";
        constexpr static auto LIGHT_MAGENTA = "\033[0;95m";
        constexpr static auto LIGHT_CYAN = "\033[0;96m";
        constexpr static auto WHITE = "\033[0;97m";
    }

    namespace Background {
        // Background colors
        constexpr static auto DEFAULT = "\033m0;49mm";
        constexpr static auto BLACK = "\033[0;40m";
        constexpr static auto RED = "\033[0;41m";
        constexpr static auto GREEN = "\033[0;42m";
        constexpr static auto YELLOW = "\033[0;43m";
        constexpr static auto BLUE = "\033[0;44m";
        constexpr static auto MAGENTA = "\033[0;45m";
        constexpr static auto CYAN = "\033[0;46m";
        constexpr static auto LIGHT_GRAY = "\033[0;47m";
        constexpr static auto DARK_GRAY = "\033[0;100m";
        constexpr static auto LIGHT_RED = "\033[0;101m";
        constexpr static auto LIGHT_GREEN = "\033[0;102m";
        constexpr static auto LIGHT_YELLOW = "\033[0;103m";
        constexpr static auto LIGHT_BLUE = "\033[0;104m";
        constexpr static auto LIGHT_MAGENTA = "\033[0;105m";
        constexpr static auto LIGHT_CYAN = "\033[0;106m";
        constexpr static auto WHITE = "\033[0;107m";
    }

    namespace Effects {
        // Effects
        constexpr static auto BOLD = "\033[0;1m";
        constexpr static auto DIM = "\033[0;2m";
        constexpr static auto UNDERLINED = "\033[0;4m";
        constexpr static auto BLINK = "\033[0;5m";
        constexpr static auto REVERSE = "\033[0;7m";
        constexpr static auto HIDDEN = "\033[0;8m";
    }
}

#endif //MATHEMAXC_COLORS_HPP
