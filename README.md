# runs

Scripts de automatización para configurar mi entorno de trabajo en diferentes sistemas operativos.

## Descripción

Este proyecto contiene scripts para instalar y configurar herramientas de desarrollo, aplicaciones de productividad y utilidades del sistema de forma automática.

## Scripts disponibles

| Script | Sistema operativo |
|--------|-------------------|
| `windows.ps1` | Windows |
| `wsl-ubuntu.sh` | WSL Ubuntu |
| `fedora.sh` | Fedora |
| `linux-mint.sh` | Linux Mint |
| `arch-linux.sh` | Arch Linux |

## Uso

### Windows

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
.\windows.ps1
```

### Linux / WSL

```bash
# Ubuntu/WSL
bash wsl-ubuntu.sh

# Fedora
bash fedora.sh

# Linux Mint
bash linux-mint.sh

# Arch Linux
bash arch-linux.sh
```

## Requisitos

- **Windows**: Winget instalado
- **Linux**: Bash y permisos de sudo