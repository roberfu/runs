$apps = @(
    "Mozilla.Firefox.es-CL",
    "Git.Git",
    "RevoUninstaller.RevoUninstaller",
    "qBittorrent.qBittorrent",
    "Notepad++.Notepad++",
    "7zip.7zip",
    "RedHat.Podman",
    "VideoLAN.VLC",
    "VSCodium.VSCodium",
    "Valve.Steam",
    "ONLYOFFICE.DesktopEditors",
    "Discord.Discord",
    "Spotify.Spotify",
    "Ventoy.Ventoy",
    "hoppscotch.Hoppscotch",
    "DBeaver.DBeaver.Community",
    "Python.Python.3.14",
    "Rustlang.Rust.GNU",
    "GoLang.Go",
    "Oracle.OpenJDK.25",
    "Gyan.FFmpeg",
    "cURL.cURL",
    "Yarn.Yarn",
    "MSYS2.MSYS2",
    "OpenJS.NodeJS.LTS",
    "Neovim.Neovim",
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.OpenJDK.25",
    "Hibbiki.Chromium"
)

function Refresh {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
    [System.Environment]::GetEnvironmentVariable("Path", "User")
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "Winget no esta instalado. Instala App Installer desde Microsoft Store."
    exit 1
}

foreach ($app in $apps) {
    Write-Host "`n>>> Instalando $app..." -ForegroundColor Cyan
    winget install --id $app --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Error al instalar $app (codigo $LASTEXITCODE). Continuando..."
    }
}

Refresh

Write-Host "`n>>> Instalando Claude Code..." -ForegroundColor Cyan
irm https://claude.ai/install.ps1 | iex

if (Get-Command rustup -ErrorAction SilentlyContinue) {
    Write-Host "`n>>> Configurando Rust..." -ForegroundColor Cyan
    rustup toolchain install stable-x86_64-pc-windows-gnu
    rustup default stable-x86_64-pc-windows-gnu
    rustup target add x86_64-pc-windows-gnu
}
  
$base = Join-Path $PSScriptRoot "..\dotfiles"
$dir = "C:\Users\$env:USERNAME"

if (-not (Test-Path $base)) {
    Write-Host "`n>>> Clonando dotfiles desde GitHub..." -ForegroundColor Cyan
    git clone https://github.com/roberfu/dotfiles.git $base
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al clonar dotfiles. Saliendo."
        exit 1
    }
}

$archivos = @(
    @{ origen = "$base\.gitconfig"; destino = "$dir\.gitconfig" },
    @{ origen = "$base\.gitattributes"; destino = "$dir\.gitattributes" },
    @{ origen = "$base\.config\VSCodium\User\settings.json"; destino = "$dir\AppData\Roaming\VSCodium\User\settings.json" }
)

foreach ($archivo in $archivos) {
    if (Test-Path $archivo.origen) {
        $carpetaDestino = Split-Path $archivo.destino -Parent
        if ($carpetaDestino -and -not (Test-Path $carpetaDestino)) {
            New-Item -ItemType Directory -Path $carpetaDestino -Force | Out-Null
            Write-Host "Carpeta creada: $carpetaDestino"
        }
        Copy-Item -Path $archivo.origen -Destination $archivo.destino -Force
        Write-Host "Copiado: $($archivo.origen)"
    }
    else {
        Write-Warning "No encontrado: $($archivo.origen)"
    }
}

$wslStatus = wsl --status 2>&1
if ($LASTEXITCODE -eq 0 -and $wslStatus -notmatch 'not installed') {
    Write-Host "`nWSL ya esta instalado."
}
else {
    Write-Host "`n>>> Instalando WSL..." -ForegroundColor Cyan
    wsl --install
}

# ==============================================================
# RECORDATORIOS POST-INSTALACION (pasos manuales)
# ==============================================================

# PATH: Agregar al PATH las herramientas/aplicaciones que lo requieran
# (por ejemplo: Go, Python, Cargo, MSYS2, etc.)

# EXTENSIONES DEL NAVEGADOR: Instalar en el explorador que se vaya a usar:
#   - Raindrop.io
#   - Bitwarden
#   - uBlock Origin
#   - Custom New Tab
#   - DuckDuckGo Privacy Essentials