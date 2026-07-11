$ErrorActionPreference = "Stop"

$LauncherRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClientRoot = Join-Path $LauncherRoot "Client"
$LocalServerRoot = Join-Path $LauncherRoot "Server"
$PreviousServerRoot = Join-Path (Split-Path -Parent $LauncherRoot) "Prototype-0.1\Server"
$Port = 17171
$LogRoot = Join-Path $LauncherRoot "Launcher-Logs"
$LogPath = Join-Path $LogRoot "host-launcher.log"

function Write-LauncherLog([string]$Message) {
    $line = "{0}  {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Add-Content -Path $LogPath -Value $line -Encoding UTF8
    Write-Host $Message
}

function Test-LocalPort([int]$PortNumber) {
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $async = $client.BeginConnect("127.0.0.1", $PortNumber, $null, $null)
        if (-not $async.AsyncWaitHandle.WaitOne(500)) { return $false }
        $client.EndConnect($async)
        return $true
    } catch {
        return $false
    } finally {
        $client.Close()
    }
}

New-Item -ItemType Directory -Force -Path $LogRoot | Out-Null
Write-LauncherLog "Hex Nexus Host launcher started."

$ClientLauncher = Join-Path $ClientRoot "startClientWin7.bat"
if (-not (Test-Path $ClientLauncher)) {
    throw "Hex Nexus client was not found at: $ClientLauncher"
}

if (Test-Path (Join-Path $LocalServerRoot "startServerWin7.bat")) {
    $ServerRoot = $LocalServerRoot
} elseif (Test-Path (Join-Path $PreviousServerRoot "startServerWin7.bat")) {
    $ServerRoot = $PreviousServerRoot
    Write-LauncherLog "Using the validated Prototype 0.1 server distribution."
} else {
    throw "Hex Nexus server was not found beside the launcher or in Prototype-0.1."
}

$ServerLauncher = Join-Path $ServerRoot "startServerWin7.bat"
if (Test-LocalPort $Port) {
    Write-LauncherLog "Server port $Port is already active; no duplicate server was started."
} else {
    Write-LauncherLog "Starting the Hex Nexus server."
    Start-Process -FilePath $ServerLauncher -WorkingDirectory $ServerRoot

    $ready = $false
    for ($attempt = 1; $attempt -le 60; $attempt++) {
        Start-Sleep -Seconds 1
        if (Test-LocalPort $Port) {
            $ready = $true
            break
        }
    }
    if (-not $ready) {
        throw "The server did not become ready on port $Port within 60 seconds. Leave the server window open and review its final message."
    }
    Write-LauncherLog "Server is ready on port $Port."
}

Write-LauncherLog "Starting the Hex Nexus client."
Start-Process -FilePath $ClientLauncher -WorkingDirectory $ClientRoot
Write-LauncherLog "Host launch completed successfully."
