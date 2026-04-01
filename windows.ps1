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
    "CoreyButler.NVMforWindows",
    "Yarn.Yarn",
    "MSYS2.MSYS2"
)

function Find-NvmRoot {
    $candidates = @(
        "$env:APPDATA\nvm",
        "$env:ProgramFiles\nvm",
        "${env:ProgramFiles(x86)}\nvm",
        "$env:LOCALAPPDATA\nvm"
    )
    foreach ($c in $candidates) {
        if (Test-Path "$c\nvm.exe") { return $c }
    }
    $fromPath = Get-Command nvm.exe -ErrorAction SilentlyContinue
    if ($fromPath) { return Split-Path $fromPath.Source }
    return $null
}

function Refresh {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")

    $nvmRoot = Find-NvmRoot
    if (-not $nvmRoot) { return }

    $env:Path = "$nvmRoot;$env:Path"

    $nvmSymlink = "$nvmRoot\current"
    if (-not (Test-Path $nvmSymlink)) { return }

    $nodeDir = (Get-Item $nvmSymlink -Force).Target
    if (-not $nodeDir) { return }
    $nodeDirResolved = $nodeDir -replace '\\current$', "\v$((& "$nvmRoot\nvm.exe" list 2>&1 | Select-String '\*' | Select-Object -First 1) -replace '.*\*\s*','' -replace '\s.*','')"

    if (Test-Path "$nodeDir\node.exe") {
        $env:Path = "$nodeDir;$env:Path"
    } else {
        $found = Get-ChildItem "$nvmRoot" -Filter "node.exe" -Recurse -Depth 2 -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            $env:Path = "$($found.DirectoryName);$env:Path"
        }
    }
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

Write-Host "`n>>> Instalando Node LTS con NVM..." -ForegroundColor Cyan

$nvmRoot = Find-NvmRoot
if ($nvmRoot) {
    $nvmExe = "$nvmRoot\nvm.exe"
    & $nvmExe install lts
    & $nvmExe use lts
    Refresh

    $nodeExe = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeExe) {
        $found = Get-ChildItem $nvmRoot -Filter "node.exe" -Recurse -Depth 2 -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            $env:Path = "$($found.DirectoryName);$env:Path"
        }
    }

    Write-Host "Node: $(node --version 2>&1)"
    Write-Host "npm:  $(npm --version 2>&1)"
} else {
    Write-Warning "nvm.exe no encontrado. Comprueba la instalacion de NVM for Windows."
}

Write-Host "`n>>> Instalando opencode-ai..." -ForegroundColor Cyan

if (Get-Command npm -ErrorAction SilentlyContinue) {
    npm install -g opencode-ai
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Error al instalar opencode-ai (codigo $LASTEXITCODE)."
    }
} else {
    Write-Warning "npm no esta disponible. No se puede instalar opencode-ai."
}

if (Get-Command rustup -ErrorAction SilentlyContinue) {
    Write-Host "`n>>> Configurando Rust..." -ForegroundColor Cyan
    rustup toolchain install stable-x86_64-pc-windows-gnu
    rustup default stable-x86_64-pc-windows-gnu
    rustup target add x86_64-pc-windows-gnu
}

$base = Join-Path $PSScriptRoot "..\dotfiles"
$dir  = "C:\Users\$env:USERNAME"

if (-not (Test-Path $base)) {
    Write-Host "`n>>> Clonando dotfiles desde GitHub..." -ForegroundColor Cyan
    git clone https://github.com/roberfu/dotfiles.git $base
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al clonar dotfiles. Saliendo."
        exit 1
    }
}

$archivos = @(
    @{ origen = "$base\.gitconfig";                           destino = "$dir\.gitconfig" },
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
    } else {
        Write-Warning "No encontrado: $($archivo.origen)"
    }
}

$wslStatus = wsl --status 2>&1
if ($LASTEXITCODE -eq 0 -and $wslStatus -notmatch 'not installed') {
    Write-Host "`nWSL ya esta instalado."
} else {
    Write-Host "`n>>> Instalando WSL..." -ForegroundColor Cyan
    wsl --install
}