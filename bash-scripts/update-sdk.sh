#!/usr/bin/env bash

# The SDK version to download
SDK_VERSION="2.5.6"

# Color definitions with Escape-Sequences
ESCAPE="\033[0;"
RESET="${ESCAPE}0m"
BOLD="${ESCAPE}1m"
LIGHT_RED="${ESCAPE}91m"
LIGHT_GREEN="${ESCAPE}92m"
LIGHT_YELLOW="${ESCAPE}93m"
LIGHT_CYAN="${ESCAPE}96m"

# Some Shortcuts for the echo statements.
START="${BOLD}${LIGHT_CYAN}::${RESET}${BOLD}"
FINISHED="${BOLD}${LIGHT_GREEN}::${RESET}${BOLD}"
ERROR="${BOLD}${LIGHT_RED}::${RESET}${BOLD}"
INPUT="${BOLD}${LIGHT_YELLOW}::${RESET}"

# Resets all the attributes before trying to print something.
echo -e "${RESET}${BOLD}${LIGHT_GREEN}Thank you for using yadrpm by MaFeLP <mafelp@protonmail.ch>!$RESET"

# Checking if the no-debug command line option was given
DEBUG=true
if [[ $1 ]];then
  if [[ $1 == "--no-debug" ]];then
    DEBUG=false
  elif [[ $1 == "--debug" ]]; then
      DEBUG=true
  fi
else
  echo -e -n "$INPUT"
  read -r -e -p " Do you want to see the output of the commands (default: n)? [y/n]: " DEBUG_INPUT
  if [[ "$DEBUG_INPUT" =~ [yY] ]];then
    DEBUG=true
  elif [[ $DEBUG_INPUT =~ [nN] ]];then
    DEBUG=false
  elif [[ $DEBUG_INPUT == "" ]];then
    DEBUG=false
  else
    echo -e "$ERROR Input could not be read. Please try again!"
    exit 1
  fi
fi

# Download discords Game SDK
echo -e "$START Downloading discord's game sdk with curl...$RESET"
if [[ $DEBUG == true ]];then
  if curl --request GET \
       --url 'https://dl-game-sdk.discordapp.net/2.5.6/discord_game_sdk.zip'\
       --output './discord_game_sdk.zip';then
    echo -e "$FINISHED Downloaded discord's game sdk successfully!$RESET"
  else
    echo -e "$ERROR Could not download discord's game sdk. curl exited with error code $?$RESET"
    echo -e "$ERROR Possible fixes:
     - Check your internet connection
     \`-> Check with 'ping google.com'
     - Do you have curl's latest version installed?
     \`-> Check with 'curl --version'$RESET"
    exit 1
  fi
else
  if curl --request GET -sL \
       --url "https://dl-game-sdk.discordapp.net/${SDK_VERSION}/discord_game_sdk.zip"\
       --output './discord_game_sdk.zip';then
    echo -e "$FINISHED Downloaded discord's game sdk successfully!$RESET"
  else
    echo -e "$ERROR Could not download discord's game sdk. curl exited with error code $?$RESET"
    echo -e "$ERROR Possible fixes:
     - Check your internet connection
     \`-> Check with 'ping google.com'
     - Do you have curl's latest version installed?
     \`-> Check with 'curl --version'$RESET"
    exit 1
  fi
fi

# Unpack the needed library...
echo -e "$START Unpacking the required library with unzip...$RESET"
if [[ $DEBUG == true ]];then
  if unzip './discord_game_sdk.zip' 'lib/x86_64/discord_game_sdk.so';then
    echo -e "$FINISHED Unpacked the library successfully!$RESET"
  else
    echo -e "$ERROR Could not unpack the library!$RESET"
    echo -e "$ERROR Possible fixes:
     - Do you have unzip's latest version installed?
     \`-> Check with 'unzip -v'$RESET"
    exit 1
  fi
else
  if unzip './discord_game_sdk.zip' 'lib/x86_64/discord_game_sdk.so' &> /dev/null;then
    echo -e "$FINISHED Unpacked the library successfully!$RESET"
  else
    echo -e "$ERROR Could not unpack the library!$RESET"
    echo -e "$ERROR Possible fixes:
     - Do you have unzip's latest version installed?
     \`-> Check with 'unzip -v'$RESET"
    exit 1
  fi
fi

# Remove older copies of the SDK
if [[ -f "./libdiscord_game_sdk.so" ]];then
  echo -e "$START Removing older version of the game SDK..."
  if rm "./libdiscord_game_sdk.so";then
    echo -e "$FINISHED Removed older version of the game SDK!"
  else
    echo -e "$ERROR Could not remove older version of the SDK. Please do this manually!"
  fi
else
  echo -e "$FINISHED No older game SDK version found!"
fi

# Move the library into the correct place
if ! mv './lib/x86_64/discord_game_sdk.so' './libdiscord_game_sdk.so';then
  echo -e "$ERROR Could not move the unpacked library to the needed place. Please do so manually!$RESET"
  exit 1
fi

# Delete the files
if rm -r './lib' './discord_game_sdk.zip';then
  echo -e "$FINISHED Moved the library successfully!$RESET"
else
  echo -e "$ERROR Could not remove the remaining, empty folders. Leaving them behind...$RESET"
fi

echo -e "$FINISHED Successfully updated the game SDK!"
exit 0