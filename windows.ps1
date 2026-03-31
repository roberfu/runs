$apps = @(
    "Mozilla.Firefox.es-CL",
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

$scoopApps = @(
    "7zip",
    "neovim",
    "python",
    "nvm",
    "yarn",
    "rustup",
    "go",
    "maven",
    "openjdk25",
    "ffmpeg",
    "curl",
    "wget",
    "mingw"
)

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Scoop..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
}

scoop bucket add extras
scoop bucket add java

foreach ($app in $scoopApps) {
    Write-Host "Instalando $app..."
    scoop install $app 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Error al instalar $app. Continuando con el siguiente..."
    }
}

Refresh

$pythonReg = "$env:USERPROFILE\scoop\apps\python\current\install-pep-514.reg"
if (Test-Path $pythonReg) {
    reg import $pythonReg
    Write-Host "Python registrado."
}

$7zipReg = "$env:USERPROFILE\scoop\apps\7zip\current\install-context.reg"
if (Test-Path $7zipReg) {
    reg import $7zipReg
    Write-Host "7-Zip registrado."
}

Write-Host "Instalando dependencias comunes..."
$deps = @(
    "make",
    "gcc",
    "vcredist2022"
)

foreach ($dep in $deps) {
    if (-not (Get-Command $dep -ErrorAction SilentlyContinue)) {
        Write-Host "Instalando $dep..."
        scoop install $dep 2>&1
    }
}

Refresh

Write-Host "Instalando versiones LTS de Node..."
try {
    nvm install lts
    nvm use lts
} catch {
    Write-Warning "NVM no disponible."
}

Refresh
npm i -g opencode-ai

rustup toolchain install stable-x86_64-pc-windows-gnu
rustup default stable-x86_64-pc-windows-gnu

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
        $carpetaDestino = Split-Path $archivo.destino -Parent
        if (-not (Test-Path $carpetaDestino)) {
            New-Item -ItemType Directory -Path $carpetaDestino -Force | Out-Null
            Write-Host "Carpeta creada: $carpetaDestino"
        }
        Copy-Item -Path $archivo.origen -Destination $archivo.destino -Force
        Write-Host "Copiado: $($archivo.origen)"
    } else {
        Write-Warning "No encontrado: $($archivo.origen)"
    }
}

$wslStatus = wsl --status 2>&1
if ($LASTEXITCODE -eq 0 -and $wslStatus -notmatch 'not installed') {
    Write-Host "WSL ya está instalado."
} else {
    Write-Host "Instalando WSL..."
    wsl --install
}
