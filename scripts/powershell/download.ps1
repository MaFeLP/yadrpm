#!/usr/bin/env pwsh

param (
  [switch]$debug = $null,
  [switch]$noDebug = $null,
  [switch]$ssh = $null,
  [switch]$http = $null
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

# Checking if the ssh/http command line args are given
if ( -Not $ssh -and -Not $http ) {
  Write-Host ":: " -ForegroundColor Yellow -NoNewline
  $DEBUG_INPUT = Read-Host -Prompt ( "Do you have ssh set up with github (default: n)? [y/n]: ")
  if ( $SSH_INPUT -ieq "y" ) {
    $SSH=$true
  } elseif ( $SSH_INPUT -ieq "n" ) {
    $SSH=$false
  } elseif ( $SSH_INPUT -ieq "" ) {
    $SSH=$false
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Input could not be read. Please try again!"
    exit
  }
} else {
  if ( $ssh ) {
    $SSH = $true
  } else {
    $SSH = $false
  }
}

# Cloning source files...
if ( $DEBUG ) {
  if ( $SSH ) {
    Write-Host ":: " -ForegroundColor Cyan -NoNewline
    Write-Host "Getting the source files with git (via ssh)..."
    git clone git@github.com:MaFeLP/yadrpm.git
    if ( $? ) {
      Write-Host -ForegroundColor Green -NoNewline
      Write-Host "Source Files downloaded!"
    } else {
      Write-Host "Could not download the source files." -ForegroundColor Red -NoNewline
      Write-Host "Possible fixes:
- Check your internet connection
\`-> Check with 'ping google.com'
- Do you have git's latest version installed?
\`-> Check with 'git --version'" -ForegroundColor Red
      exit
    }
   } else {
    Write-Host ":: " -ForegroundColor Cyan -NoNewline
    Write-Host "Getting the source files with git (via ssh)..."
    git clone https://github.com/MaFeLP/yadrpm.git
    if ( $? ) {
      Write-Host "Source Files downloaded!"
    } else {
      if ( $? ) {
        Write-Host -ForegroundColor Green -NoNewline
        Write-Host "Source Files downloaded!"
      } else {
        Write-Host "Could not download the source files." -ForegroundColor Red -NoNewline
        Write-Host "Possible fixes:
- Check your internet connection
\`-> Check with 'ping google.com'
- Do you have git's latest version installed?
\`-> Check with 'git --version'" -ForegroundColor Red
        exit
      } 
    }
  }
} else {
    if ( $SSH ) {
    Write-Host ":: " -ForegroundColor Cyan -NoNewline
    Write-Host "Getting the source files with git (via ssh)..."
    git clone git@github.com:MaFeLP/yadrpm.git | Out-Null
    if ( $? ) {
      Write-Host -ForegroundColor Green -NoNewline
      Write-Host "Source Files downloaded!"
    } else {
      Write-Host "Could not download the source files." -ForegroundColor Red -NoNewline
      Write-Host "Possible fixes:
- Check your internet connection
\`-> Check with 'ping google.com'
- Do you have git's latest version installed?
\`-> Check with 'git --version'" -ForegroundColor Red
      exit
    }
   } else {
    Write-Host ":: " -ForegroundColor Cyan -NoNewline
    Write-Host "Getting the source files with git (via ssh)..."
    git clone https://github.com/MaFeLP/yadrpm.git | Out-Null
    if ( $? ) {
      Write-Host "Source Files downloaded!"
    } else {
      if ( $? ) {
        Write-Host -ForegroundColor Green -NoNewline
        Write-Host "Source Files downloaded!"
      } else {
        Write-Host "Could not download the source files." -ForegroundColor Red -NoNewline
        Write-Host "Possible fixes:
- Check your internet connection
\`-> Check with 'ping google.com'
- Do you have git's latest version installed?
\`-> Check with 'git --version'" -ForegroundColor Red
        exit
      } 
    }
  }
}

# Change into the github repository!
Set-Location -Path .\yadrpm
if ( -Not $? ) {
  Write-Host ":: " -ForegroundColor Red -NoNewline
  Write-Host "Could not change the directory... Exiting!"
  exit
}

# Download discords Game SDK
if ( $DEBUG ) {
  .\scripts\powershell\update-sdk.ps1 --debug --no-delete-sources
  if ( $? ) {
    .\scripts\powershell\update-sdk-sources.ps1 --debug
      if ( $? ) {
        .\scripts\powershell\make.ps1 --debug
        if ( $? ) {
          Write-Host ":: " -ForegroundColor Green -NoNewline
          Write-Host "Update done!"
          exit
        } else {
          Write-Host ":: " -ForegroundColor Red -NoNewline
          Write-Host "Something went wrong, in the making process!"
          exit
        }
     } else {
       Write-Host ":: " -ForegroundColor Red -NoNewline
       Write-Host "Something went wrong, in the game-sdk-sources-updating process!"
       exit
     }
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Something went wrong, in the game SDK updating process!"
    exit
  }
} else {
  .\scripts\powershell\update-sdk.ps1 -debug -noDeleteSources
  if ( $? ) {
    .\scripts\powershell\update-sdk-sources.ps1 -debug
      if ( $? ) {
        .\scripts\powershell\make.ps1 -debug
        if ( $? ) {
          Write-Host ":: " -ForegroundColor Green -NoNewline
          Write-Host "Update done!"
          exit
        } else {
          Write-Host ":: " -ForegroundColor Red -NoNewline
          Write-Host "Something went wrong, in the making process!"
          exit
        }
     } else {
       Write-Host ":: " -ForegroundColor Red -NoNewline
       Write-Host "Something went wrong, in the game-sdk-sources-updating process!"
       exit
     }
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Something went wrong, in the game SDK updating process!"
    exit
  }
}