#!/usr/bin/env pwsh

param (
  [switch]$debug = $null,
  [switch]$noDebug = $null
)

Write-Host "Thank you for using yadrpm by MaFeLP <mafelp@protonmail.ch>!" -ForegroundColor Green

# Checking if the no-debug command line option was given
if ( -Not $debug -and -Not $noDebug ) {
  Write-Host ":: " -ForegroundColor Yellow -NoNewline
  $DEBUG_INPUT = Read-Host -Prompt ( "Do you want to see the output of the commands (default: n)? [y/n]")
  if ( $DEBUG_INPUT -ieq "y" ) {
    $DEBUG=$true
  } elseif ( $DEBUG_INPUT -ieq "n" ) {
    $DEBUG=$false
  } elseif ( $DEBUG_INPUT -ieq "" ) {
    $DEBUG=$false
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Input could not be read. Please try again!"
    exit
  }
} else {
  if ( $debug ) {
    $DEBUG = $true
  } else {
    $DEBUG = $false
  }
}

# Remove the old executable file.
if ( Test-Path -Path "yadrpm" -PathType Leaf ) {
  Write-Host ":: " -ForegroundColor Cyan -NoNewline
  Write-Host "Removing old executable file..."
  Remove-Item -Path "yadrpm"
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    "Successfully removed old executable file."
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Could not remove old executable file."
  }
} else {
  Write-Host ":: " -ForegroundColor Green -NoNewline
  Write-Host "Old executable file already removed!"
}

# Building the makefile
if ( $DEBUG ) {
  Write-Host ":: " -ForegroundColor Cyan -NoNewline
  Write-Host "Building makefile with cmake..."
  cmake CMakeLists.txt
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    Write-Host 'Successfully built "Makefile"!'
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host 'Could not build build "Makefile"!'
    exit
  }
} else {
  Write-Host ":: " -ForegroundColor Cyan -NoNewline
  Write-Host "Building makefile with cmake..."
  cmake CMakeLists.txt | Out-Null
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    Write-Host 'Successfully built "Makefile"!'
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host 'Could not build build "Makefile"!'
    exit
  }
}

# Building the executable
if ( $DEBUG ) {
  Write-Host ":: " -ForegroundColor Cyan -NoNewline
  Write-Host "Building the executable with make..."
  make
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    Write-Host "Successfully built the executable!"
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Could not build build the executable!"
    exit
  }
} else {
  Write-Host ":: " -ForegroundColor Cyan -NoNewline
  Write-Host "Building the executable with make..."
  make | Out-Null
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    Write-Host "Successfully built the executable!"
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Could not build build the executable!"
    exit
  }
}

# Cleaning the build directory
Write-Host ":: " -ForegroundColor Cyan -NoNewline
Write-Host "Cleaning up build directory..."
Remove-Item -Path ("CMakeCache.txt", "CMakeFiles", "cmake_install.cmake", "Makefile") -Recurse
if ( $? ) {
  Write-Host ":: " -ForegroundColor Green -NoNewline
  Write-Host "Successfully cleaned up build directory!"
} else {
  Write-Host ":: " -ForegroundColor Red -NoNewline
  Write-Host "Could not clean up build directory!"
}