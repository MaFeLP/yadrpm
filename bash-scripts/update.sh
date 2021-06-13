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

# Getting latest source files.
echo -e "$START Getting latest source files from github..."
if [[ $DEBUG == true ]];then
  if git pull;then
    echo -e "$FINISHED Successfully pulled the sources!"
  else
    echo -e "$ERROR Could not pull sources. git exited with error code $?"
      echo -e "$ERROR Possible fixes:
   - Check your internet connection
   \`-> Check with 'ping google.com'
   - Do you have git's latest version installed?
   \`-> Check with 'git --version'$RESET"
      exit 1
  fi
else
  if git pull &> /dev/null;then
    echo -e "$FINISHED Successfully pulled the sources!"
  else
    echo -e "$ERROR Could not pull sources. git exited with error code $?"
      echo -e "$ERROR Possible fixes:
   - Check your internet connection
   \`-> Check with 'ping google.com'
   - Do you have git's latest version installed?
   \`-> Check with 'git --version'$RESET"
      exit 1
  fi
fi

if [[ $DEBUG == true ]];then
  if bash ./bash-scripts/update-sdk.sh --debug;then
    if bash ./bash-scripts/make.sh --debug;then
      echo -e "$FINISHED Update done!$RESET"
      exit 0
    else
      echo -e "$ERROR Something went wrong, in the making process!"
      exit 1
    fi
  else
    echo -e "$ERROR Something went wrong, in the game SDK updateing process!"
    exit 1
  fi
else
  if bash ./bash-scripts/update-sdk.sh --no-debug;then
    if bash ./bash-scripts/make.sh --no-debug;then
      echo -e "$FINISHED Update done!"
      exit 0
    else
      echo -e "$ERROR Something went wrong, in the making process!"
      exit 1
    fi
  else
    echo -e "$ERROR Something went wrong, in the game SDK updateing process!"
    exit 1
  fi
fi