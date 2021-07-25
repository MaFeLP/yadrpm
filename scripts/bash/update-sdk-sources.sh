#!/usr/bin/env bash

# The SDK version to download
SDK_VERSION="3.1.0"

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
if [[ -f "./discord_game_sdk.zip" ]];then
  echo -e "$FINISHED Found already downloaded source files! Using them...$RESET"
else
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
fi

# Unpack the needed library...
echo -e "$START Unpacking the required library with unzip...$RESET"
if [[ $DEBUG == true ]];then
  if unzip './discord_game_sdk.zip' 'cpp/*.cpp' 'cpp/*.h';then
    echo -e "$FINISHED Unpacked the source files successfully!$RESET"
  else
    echo -e "$ERROR Could not unpack the source files!$RESET"
    echo -e "$ERROR Possible fixes:
     - Do you have unzip's latest version installed?
     \`-> Check with 'unzip -v'$RESET"
    exit 1
  fi
else
  if unzip './discord_game_sdk.zip' 'cpp/*.cpp' 'cpp/*.h' &> /dev/null;then
    echo -e "$FINISHED Unpacked the source files successfully!$RESET"
  else
    echo -e "$ERROR Could not unpack the source files!$RESET"
    echo -e "$ERROR Possible fixes:
     - Do you have unzip's latest version installed?
     \`-> Check with 'unzip -v'$RESET"
    exit 1
  fi
fi

# Remove older copies of the SDK source files
if [[ -d "./src/discord" ]];then
  echo -e "$START Removing older version of the game SDK..."
  if rm -rf "./src/discord";then
    echo -e "$FINISHED Removed older version of the game SDK!"
  else
    echo -e "$ERROR Could not remove older version of the SDK. Please do this manually!"
  fi
else
  echo -e "$FINISHED No older game SDK version found!"
fi

# Move the library into the correct place
if ! mv './cpp/' './src/discord/';then
  echo -e "$ERROR Could not move the unpacked source files to the needed place. Please do so manually!$RESET"
  exit 1
fi

# Delete the files
if rm -r './discord_game_sdk.zip';then
  echo -e "$FINISHED Moved the source files successfully!$RESET"
else
  echo -e "$ERROR Could not remove the remaining, empty folders. Leaving them behind...$RESET"
fi

# Patching wrong configured files
if [[ $DEBUG == true ]];then
  if patch ./src/discord/types.h ./patches/src/discord/types.h.patch;then
    echo -e "$FINISHED Applied patch to src/discord/types.h"
  else
    echo -e "$ERROR Could not apply patch for file src/discord/types.h! path exited with exit code $RESET$?"
  fi
else
  if patch ./src/discord/types.h ./patches/src/discord/types.h.patch &> /dev/null;then
    echo -e "$FINISHED Applied patch to types.h"
  else
    echo -e "$ERROR Could not apply patch for file src/discord/types.h! path exited with exit code $RESET$?"
  fi
fi
