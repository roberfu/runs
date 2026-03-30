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
    "Ventoy.Ventoy",
    "hoppscotch.Hoppscotch",
    "DBeaver.DBeaver.Community",
    "Yarn.Yarn",
    "Rustlang.Rustup",
    "GoLang.Go",
    "Microsoft.VisualStudio.BuildTools"
)

function Refresh {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

foreach ($app in $apps) {
    winget install --id $app --silent --accept-package-agreements --accept-source-agreements
}

Refresh

try {
    nvm install lts
    nvm use lts
} catch {
    Write-Warning "NVM no disponible. Revisa esta seccion en el archivo y vuelve a ejecutar este codigo mas tarde."
}

Refresh

$base = Join-Path $PSScriptRoot "..\dotfiles"
$dir = "C:\Users\Roberto"

$archivos = @(
    @{ origen = "$base\.gitconfig"; destino = "$dir\.gitconfig" },
    @{ origen = "$base\.config\VSCodium\User\settings.json"; destino = "$dir\AppData\Roaming\VSCodium\User\settings.json" }
)

foreach ($archivo in $archivos) {
    Copy-Item -Path $archivo.origen -Destination $archivo.destino -Force
}

wsl --install
