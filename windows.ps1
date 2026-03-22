$apps = @(
    "Brave.Brave",
    "7zip.7zip",
    "Git.Git",
    "Neovim.Neovim",
    "Microsoft.VCRedist.2015+.x64",
    "RevoUninstaller.RevoUninstaller",
    "qBittorrent.qBittorrent",
    "Notepad++.Notepad++",
    "Python.Python.3.14",
    "CoreyButler.NVMforWindows",
    "Oracle.JDK.25",
    "RedHat.Podman",
    "VideoLAN.VLC",
    "VSCodium.VSCodium",
    "Valve.Steam",
    "ONLYOFFICE.DesktopEditors",
    "Discord.Discord",
    "Gyan.FFmpeg",
    "Spotify.Spotify",
    "Ventoy.Ventoy"
)

function Refresh-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

foreach ($app in $apps) {
    winget install --id $app --silent --accept-package-agreements --accept-source-agreements
}

Refresh-Path

nvm install lts
nvm use lts

Refresh-Path

$origen = Join-Path $PSScriptRoot "\..\dotfiles\.gitconfig"
$destino = "C:\Users\Roberto\.gitconfig"

Copy-Item -Path $origen -Destination $destino -Force