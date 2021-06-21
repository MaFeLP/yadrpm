#!/usr/bin/env pwsh

Write-Host "Thank you for using yadrpm by MaFeLP <mafelp@protonmail.ch>!" -ForegroundColor Green

Write-Host ":: " -ForegroundColor Yellow -NoNewline
$DEBUG_INPUT = Read-Host -Prompt ( "Do you want to see the output of the commands (default: n)? [y/n]: ")
if ( $DEBUG_INPUT -ieq "y" ) {
  $DEBUG=$true
} elseif ( $DEBUG_INPUT -ieq "n" ) {
  $DEBUG=$false
} elseif ( $DEBUG_INPUT -ieq "" ) {
  $DEBUG=$false
} else {
  Write-Host ":: " -ForegroundColor Red -NoNewline
  Write-Host "Input could not be read. Please try again!"
  Exit-PSSession
}

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
  Exit-PSSession
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
      Exit-PSSession
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
        Exit-PSSession
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
      Exit-PSSession
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
        Exit-PSSession
      } 
    }
  }
}

# Change into the github repository!
Set-Location -Path .\yadrpm
if ( -Not $? ) {
  Write-Host ":: " -ForegroundColor Red -NoNewline
  Write-Host "Could not change the directory... Exiting!"
  Exit-PSSession
}

# Download discords Game SDK
if ( $DEBUG ) {
  .\powershell-scripts\update-sdk.ps1 --debug --no-delete-sources
  if ( $? ) {
    .\powershell-scripts\update-sdk-sources.ps1 --debug
      if ( $? ) {
        .\powershell-scripts\make.ps1 --debug
        if ( $? ) {
          Write-Host ":: " -ForegroundColor Green -NoNewline
          Write-Host "Update done!"
          Exit-PSSession
        } else {
          Write-Host ":: " -ForegroundColor Red -NoNewline
          Write-Host "Something went wrong, in the making process!"
          Exit-PSSession
        }
     } else {
       Write-Host ":: " -ForegroundColor Red -NoNewline
       Write-Host "Something went wrong, in the game-sdk-sources-updating process!"
       Exit-PSSession
     }
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Something went wrong, in the game SDK updating process!"
    Exit-PSSession
  }
} else {
  .\powershell-scripts\update-sdk.ps1 --debug --no-delete-sources
  if ( $? ) {
    .\powershell-scripts\update-sdk-sources.ps1 --debug
      if ( $? ) {
        .\powershell-scripts\make.ps1 --debug
        if ( $? ) {
          Write-Host ":: " -ForegroundColor Green -NoNewline
          Write-Host "Update done!"
          Exit-PSSession
        } else {
          Write-Host ":: " -ForegroundColor Red -NoNewline
          Write-Host "Something went wrong, in the making process!"
          Exit-PSSession
        }
     } else {
       Write-Host ":: " -ForegroundColor Red -NoNewline
       Write-Host "Something went wrong, in the game-sdk-sources-updating process!"
       Exit-PSSession
     }
  } else {
    Write-Host ":: " -ForegroundColor Red -NoNewline
    Write-Host "Something went wrong, in the game SDK updating process!"
    Exit-PSSession
  }
}
