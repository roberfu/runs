$apps = @(
    "Hibbiki.Chromium",
    "Git.Git",
    "RevoUninstaller.RevoUninstaller",
    "qBittorrent.qBittorrent",
    "Notepad++.Notepad++",
    "Python.Python.3.14",
    "CoreyButler.NVMforWindows"
)

foreach ($app in $apps) {
    winget install --id $app --silent --accept-package-agreements --accept-source-agreements
}

$origen = Join-Path $PSScriptRoot "\..\.dotfiles\.gitconfig"
$destino = "C:\Users\Roberto\.gitconfig"

Copy-Item -Path $origen -Destination $destino -Force
