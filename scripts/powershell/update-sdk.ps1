#!/usr/bin/env pwsh

param (
  [switch]$debug = $null,
  [switch]$noDebug = $null,
  [string]$sdk_version = "3.1.0",
  [switch]$NoDelteSources = $false
)

#Add-Type -AssemblyName System.IO.Compression.FileSystem

$SDK_VERSION = $sdk_version

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

# Download discords Game SDK
Write-Host ":: " -ForegroundColor Cyan -NoNewline
Write-Host "Downloading discord's game sdk..."
if ( Test-Path -Path ".\discord_game_sdk.zip" -PathType Leaf ) {
  Write-Host ":: " -ForegroundColor Green -NoNewline
  Write-Host "Found already downloaded source files! Using them..."
} else {
  if ( $DEBUG ) {
    Invoke-WebRequest -Uri https://dl-game-sdk.discordapp.net/${SDK_VERSION}/discord_game_sdk.zip -Method GET -OutFile .\discord_game_sdk.zip
    if ( $? ) {
      Write-Host ":: " -ForegroundColor Green -NoNewline
      Write-Host "Downloaded discord's game sdk successfully!"
    } else {
      Write-Host ":: " -ForegroundColor Red -NoNewline
      write-Host "Could not download discord's game sdk. curl exited with error code $?"
      Write-Host ":: " -ForegroundColor Red -NoNewline
      Write-Host "Possible fixes:
 - Check your internet connection
 \`-> Check with 'ping google.com'"
      exit 1
    }
  } else {
    if ( $DEBUG ) {
      Invoke-WebRequest -Uri "https://dl-game-sdk.discordapp.net/${SDK_VERSION}/discord_game_sdk.zip" -Method GET -OutFile .\discord_game_sdk.zip
      if ( $? ) {
        Write-Host ":: " -ForegroundColor Green -NoNewline
        Write-Host "Downloaded discord's game sdk successfully!"
      } else {
        Write-Host ":: " -ForegroundColor Red -NoNewline
        write-Host "Could not download discord's game sdk. curl exited with error code $?"
        Write-Host ":: " -ForegroundColor Red -NoNewline
        Write-Host "Possible fixes:
 - Check your internet connection
 \`-> Check with 'ping google.com'"
        exit 1
      }
    } else {
      Invoke-WebRequest -Uri "https://dl-game-sdk.discordapp.net/${SDK_VERSION}/discord_game_sdk.zip" -Method GET -OutFile .\discord_game_sdk.zip | Out-Null
      if ( $? ) {
        Write-Host ":: " -ForegroundColor Green -NoNewline
        Write-Host "Downloaded discord's game sdk successfully!"
      } else {
        Write-Host ":: " -ForegroundColor Red -NoNewline
        write-Host "Could not download discord's game sdk. curl exited with error code $?"
        Write-Host ":: " -ForegroundColor Red -NoNewline
        Write-Host "Possible fixes:
 - Check your internet connection
 \`-> Check with 'ping google.com'"
        exit 1
      }
    }
  }
}

# Unpack the needed library...
Write-Host ":: " -ForegroundColor Cyan -NoNewline
Write-Host "Unpacking the required library with unzip..."
if ( $DEBUG ) {
  Expand-Archive -Path ".\discord_game_sdk.zip" -DestinationPath ".\discord_game_sdk"
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    Write-Host "Unpacked the source files successfully!"
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Could not unpack the source files!"
    exit 1
  }
} else {
  Expand-Archive -Path ".\discord_game_sdk.zip" -DestinationPath ".\discord_game_sdk" | Out-Null
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    Write-Host "Unpacked the source files successfully!"
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Could not unpack the source files!"
    Write-Host ":: " -ForegroundColor Red -NoNewline
    exit 1
  }
}

# Remove older copies of the SDK source files
if ( Test-Path -Path (".\discord_game_sdk.dll", ".\discord_game_sdk.dll.lib") ) {
  Write-Host ":: " -ForegroundColor Cyan -NoNewline
  Write-Host "Removing older version of the game SDK..."
  Remove-Item -Path ".\src/discord" -Recurse
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    Write-Host "Removed older version of the game SDK!"
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Could not remove older version of the SDK. Please do this manually!"
  }
} else {
  Write-Host ":: " -ForegroundColor Green -NoNewline
  Write-Host "No older game SDK version found!"
}

# Move the source files into the correct place
Move-Item -Path (".\discord_game_sdk\lib\x86_64\discord_game_sdk.dll", ".\discord_game_sdk\lib\x86_64\discord_game_sdk.dll.lib")  -Destination "." -Force
if ( $? ) {
  Write-Host ":: " -ForegroundColor Green -NoNewline
  Write-Host "Moved the source files to src/discord!"
} else {
  Write-Host ":: " -ForegroundColor Red -NoNewline
  Write-Host "Could not move the unpacked source files to the needed place. Please do so manually!"
  exit 1
}

# Delete the files
if ( -Not $NoDelteSources ) {
  Remove-Item -Path ".\discord_game_sdk", ".\discord_game_sdk.zip" -Recurse
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    Write-Host "Moved the source files successfully!"
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Could not remove the remaining, empty folders. Leaving them behind..."
  }
}
