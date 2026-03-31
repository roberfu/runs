$apps = @(
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

function Refresh {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Scoop..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
}

scoop bucket add extras
scoop bucket add java
scoop bucket add nerd-fonts

foreach ($app in $apps) {
    Write-Host "Instalando $app..."
    scoop install $app 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Error al instalar $app. Continuando con el siguiente..."
    }
}

Refresh

Write-Host "Instalando Hack Nerd Font..."
scoop install Hack-NF 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Error al instalar Hack Nerd Font."
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

Write-Host "Instalando versiones LTS de Node y Python..."
try {
    nvm install lts
    nvm use lts
} catch {
    Write-Warning "NVM no disponible."
}

python -m pip install --upgrade pip