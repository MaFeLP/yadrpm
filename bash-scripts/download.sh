#!/usr/bin/env bash

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

echo -e -n "$INPUT"
read -r -e -p " Do you have ssh set up with github (default: n)? [y/n]: " SSH_INPUT
if [[ "$SSH_INPUT" =~ [yY] ]];then
  SSH=true
elif [[ $SSH_INPUT =~ [nN] ]];then
  SSH=false
elif [[ $SSH_INPUT == "" ]];then
  SSH=false
else
  echo -e "$ERROR Input could not be read. Please try again!"
  exit 1
fi

# Cloning source files...
if [[ $DEBUG == true ]];then
  if [[ $SSH == true ]];then
    echo -e "$START Getting the source files with git (via ssh)...$RESET"
    if git clone git@github.com:MaFeLP/yadrpm.git;then
      echo -e "$FINISHED Source Files downloaded!$RESET"
    else
      echo -e "$ERROR Could not download the source files. git exited with error code $?$RESET"
      echo -e "$ERROR Possible fixes:
       - Check your internet connection
       \`-> Check with 'ping google.com'
       - Do you have git's latest version installed?
       \`-> Check with 'git --version'$RESET"
      exit 1
    fi
  else
    echo -e "$START Getting the source files with git (via https)...$RESET"
    if git clone https://github.com/MaFeLP/yadrpm.git;then
      echo -e "$FINISHED Source Files downloaded!$RESET"
    else
      echo -e "$ERROR Could not download the source files. git exited with error code $?$RESET"
      echo -e "$ERROR Possible fixes:
       - Check your internet connection
       \`-> Check with 'ping google.com'
       - Do you have git's latest version installed?
       \`-> Check with 'git --version'$RESET"
      exit 1
    fi
  fi
else
  if [[ $SSH == true ]];then
    echo -e "$START Getting the source files with git (via ssh)...$RESET"
    if git clone git@github.com:MaFeLP/yadrpm.git &> /dev/null;then
      echo -e "$FINISHED Source Files downloaded!$RESET"
    else
      echo -e "$ERROR Could not download the source files. git exited with error code $?$RESET"
      echo -e "$ERROR Possible fixes:
       - Check your internet connection
       \`-> Check with 'ping google.com'
       - Do you have git's latest version installed?
       \`-> Check with 'git --version'$RESET"
      exit 1
    fi
  else
    echo -e "$START Getting the source files with git (via https)...$RESET"
    if git clone https://github.com/MaFeLP/yadrpm.git &> /dev/null;then
      echo -e "$FINISHED Source Files downloaded!$RESET"
    else
      echo -e "$ERROR Could not download the source files. git exited with error code $?$RESET"
      echo -e "$ERROR Possible fixes:
       - Check your internet connection
       \`-> Check with 'ping google.com'
       - Do you have git's latest version installed?
       \`-> Check with 'git --version'$RESET"
      exit 1
    fi
  fi
fi

# Change into the github repository!
if ! cd yadrpm;then
  echo -e "$ERROR Could not change directory to the git repository!$RESET"
  exit 1
fi

# Download discords Game SDK
if [[ $DEBUG == true ]];then
  if bash ./bash-scripts/update-sdk.sh --debug --no-delete-sources;then
    if bash ./bash-scripts/update-sdk-sources.sh --debug;then
      if bash ./bash-scripts/make.sh --debug;then
        echo -e "$FINISHED Update done!$RESET"
        exit 0
      else
        echo -e "$ERROR Something went wrong, in the making process!"
        exit 1
      fi
    else
      echo -e "$ERROR Something went wrong, in the game-sdk-sources-updating process!"
      exit 1
    fi
  else
    echo -e "$ERROR Something went wrong, in the game SDK updating process!"
    exit 1
  fi
else
  if bash ./bash-scripts/update-sdk.sh --no-debug --no-delete-sources;then
    if bash ./bash-scripts/update-sdk-sources.sh --no-debug;then
      if bash ./bash-scripts/make.sh --no-debug;then
        echo -e "$FINISHED Update done!"
        exit 0
      else
        echo -e "$ERROR Something went wrong, in the making process!"
        exit 1
      fi
    else
      echo -e "$ERROR Something went wrong, in the game-sdk-sources-updating process!"
      exit 1
    fi
  else
    echo -e "$ERROR Something went wrong, in the game SDK updating process!"
    exit 1
  fi
fi

echo -e "${FINISHED} Done!"
exit 0