$apps = @(
    "Mozilla.Firefox",
    "Git.Git",
    "RevoUninstaller.RevoUninstaller",
    "qBittorrent.qBittorrent",
    "Notepad++.Notepad++",
    "RedHat.Podman",
    "VideoLAN.VLC",
    "VSCodium.VSCodium",
    "Valve.Steam",
    "ONLYOFFICE.DesktopEditors",
    "Discord.Discord",
    "Spotify.Spotify",
    "Ventoy.Ventoy",
    "hoppscotch.Hoppscotch",
    "DBeaver.DBeaver.Community"
)

function Refresh {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "Winget no está instalado. Instala App Installer desde Microsoft Store."
    exit 1
}

foreach ($app in $apps) {
    Write-Host "Instalando $app..."
    $result = winget install --id $app --silent --accept-package-agreements --accept-source-agreements 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Error al instalar $app. Continuando con el siguiente..."
    }
}

Refresh

$base = Join-Path $PSScriptRoot "..\dotfiles"
$dir = "C:\Users\$env:USERNAME"

if (-not (Test-Path $base)) {
    Write-Host "Clonando dotfiles desde GitHub..."
    git clone https://github.com/roberfu/dotfiles.git $base
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al clonar dotfiles. Saliendo."
        exit 1
    }
}

$archivos = @(
    @{ origen = "$base\.gitconfig"; destino = "$dir\.gitconfig" },
    @{ origen = "$base\.config\VSCodium\User\settings.json"; destino = "$dir\AppData\Roaming\VSCodium\User\settings.json" }
)

foreach ($archivo in $archivos) {
    if (Test-Path $archivo.origen) {
        Copy-Item -Path $archivo.origen -Destination $archivo.destino -Force
        Write-Host "Copiado: $($archivo.origen)"
    } else {
        Write-Warning "No encontrado: $($archivo.origen)"
    }
}

$wslCheck = wsl --list --quiet 2>$null
if ([string]::IsNullOrWhiteSpace($wslCheck)) {
    Write-Host "Instalando WSL..."
    wsl --install
} else {
    Write-Host "WSL ya esta instalado."
}
