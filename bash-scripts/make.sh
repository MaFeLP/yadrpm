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

# Remove the old executable file.
if [[ -f "yadrpm" ]];then
  echo -e "$START Removing old executable file...$RESET"
  if rm yadrpm;then
    echo -e "$FINISHED Successfully removed old executable file.$RESET"
  else
    echo -e "$ERROR Could not remove old executable file. rm exited with exit code $?$RESET"
  fi
else
  echo -e "$FINISHED Old executable file already removed!$RESET"
fi

# Building the makefile
if [[ $DEBUG == "true" ]];then
  echo -e "$START Building makefile with cmake...$RESET"
  if cmake CMakeLists.txt;then
    echo -e "$FINISHED Successfully built \"Makefile\"!"
  else
    echo -e "$ERROR Could not build build \"Makefile\"! cmake exited with error code $?"
    exit 1
  fi
else
  echo -e "$START Building makefile with cmake and without output...$RESET"
  if cmake CMakeLists.txt &> /dev/null;then
    echo -e "$FINISHED Successfully built \"Makefile\"!"
  else
    echo -e "$ERROR Could not build build \"Makefile\"! cmake exited with error code $?"
    exit 1
  fi
fi

# Building the executable
if [[ $DEBUG == "true" ]];then
  echo -e "$START Building the executable with make...$RESET"
  if make;then
    echo -e "$FINISHED Successfully built the executable!"
  else
    echo -e "$ERROR Could not build the executable. make exited with error code $?"
    exit 1
  fi
else
  echo -e "$START Building the executable with make and without output...$RESET"
  if make &> /dev/null;then
    echo -e "$FINISHED Successfully built the executable!"
  else
    echo -e "$ERROR Could not build the executable. make exited with error code $?"
    exit 1
  fi
fi

# Cleaning the build directory
echo -e "$START Cleaning up build directory...$RESET"
if rm -r CMakeCache.txt CMakeFiles cmake_install.cmake Makefile;then
  echo -e "$FINISHED Successfully cleaned up build directory!"
else
  echo -e "$ERROR Could not clean up build directory! rm exited with error code $?"
fi

# Making the executable executable.
echo -e "$START Making the executable executable...$RESET"
if chmod +x yadrpm;then
  echo -e "$FINISHED Successfully made the executable executable!"
else
  echo -e "$ERROR Could not make the executable executable! chmod exited with exit code $?"
  exit 1
fi

# Exiting with a success.
echo -e "$FINISHED Done!"
exit 0