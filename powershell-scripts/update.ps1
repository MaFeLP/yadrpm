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

# Getting latest source files.
Write-Host ":: " -ForegroundColor Cyan -NoNewline
Write-Host "Getting latest source files from github..."
if ( $DEBUG ) {
  git pull
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    Write-Host "Successfully pulled the sources!"
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Could not pull sources."
    Write-Host "Possible fixes:
 - Check your internet connection
 \`-> Check with 'ping google.com'
 - Do you have git's latest version installed?
 \`-> Check with 'git --version'"
      exit 1
  }
} else {
  git pull | Out-Null
  if ( $? ) {
    Write-Host ":: " -ForegroundColor Green -NoNewline
    Write-Host "Successfully pulled the sources!"
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Could not pull sources."
    Write-Host "Possible fixes:
 - Check your internet connection
 \`-> Check with 'ping google.com'
 - Do you have git's latest version installed?
 \`-> Check with 'git --version'"
      exit 1
  }
}

# Download discords Game SDK
if ( $DEBUG ) {
  .\powershell-scripts\update-sdk.ps1 -debug -noDeleteSources
  if ( $? ) {
    .\powershell-scripts\update-sdk-sources.ps1 -debug
    if ( $? ) {
      .\powershell-scripts\make.ps1 -debug
      if ( $? ) {
        Write-Host ":: " -ForegroundColor Green -NoNewline
        Write-Host "Update done!"
      } else {
        Write-Host ":: " -ForegroundColor Red -NoNewline
        Write-Host "Something went wrong, in the making process!"
        exit 1
      }
    } else {
      Write-Host ":: " -ForegroundColor Red -NoNewline
      Write-Host "Something went wrong, in the game-sdk-sources-updating process!"
      exit 1
    }
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Something went wrong, in the game SDK updating process!"
    exit 1
  }
} else {
  .\powershell-scripts\update-sdk.ps1 -noDebug -noDeleteSources
  if ( $? ) {
    .\powershell-scripts\update-sdk-sources.ps1 -noDebug
    if ( $? ) {
      .\powershell-scripts\make.ps1 -noDebug
      if ( $? ) {
        Write-Host ":: " -ForegroundColor Green -NoNewline
        Write-Host "Update done!"
      } else {
        Write-Host ":: " -ForegroundColor Red -NoNewline
        Write-Host "Something went wrong, in the making process!"
        exit 1
      }
    } else {
      Write-Host ":: " -ForegroundColor Red -NoNewline
      Write-Host "Something went wrong, in the game-sdk-sources-updating process!"
      exit 1
    }
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Something went wrong, in the game SDK updating process!"
    exit 1
  }
}
