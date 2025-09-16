# NixOS Kiosk Deployment

This repository contains a modular NixOS kiosk deployment system with Openbox + Tint2 desktop environment.

## 🚀 Quick Start

### Interactive Deployment (Recommended)
```bash
./simple-deploy.sh
```
This will:
- Show available disks
- Let you select the target disk (works with `sda`, `nvme0n1`, etc.)
- Guide you through the configuration
- Deploy NixOS kiosk system

### Custom Configuration
```bash
# Set environment variables for custom configuration
DISK=/dev/nvme0n1 HOSTNAME=my-kiosk KIOSK_USER=operator ./simple-deploy.sh

# Or use individual variables
export DISK=/dev/sda
export HOSTNAME=kiosk-001
export KIOSK_USER=kiosk
export KIOSK_URL=https://my-app.local
./simple-deploy.sh
```

## 📋 Configuration Options

| Variable | Default | Description |
|----------|---------|-------------|
| `DISK` | *(interactive)* | Target disk device (e.g., `/dev/sda`, `/dev/nvme0n1`) |
| `HOSTNAME` | `kiosk-001` | System hostname |
| `KIOSK_USER` | `kiosk` | Kiosk username |
| `KIOSK_PASSWORD` | *(empty)* | User password (empty = passwordless) |
| `TIMEZONE` | `UTC` | System timezone |
| `LOCALE` | `en_US.UTF-8` | System locale |
| `KIOSK_URL` | `https://factory-app.local` | URL to open in kiosk mode |
| `BOOT_SIZE` | `512MB` | EFI boot partition size |
| `SWAP_SIZE` | `8GB` | Swap partition size |

## 🔧 Disk Support

The deployment script automatically detects and supports:
- **SATA disks**: `/dev/sda`, `/dev/sdb`, etc.
- **NVMe disks**: `/dev/nvme0n1`, `/dev/nvme1n1`, etc.
- **SCSI disks**: `/dev/sdc`, etc.

No hardcoded disk references - works with any valid block device!

## 📁 Project Structure

```
├── simple-deploy.sh          # Main deployment script
├── scripts/                  # Modular deployment scripts
│   ├── partition.sh          # Disk partitioning & formatting
│   ├── mount.sh              # Partition mounting
│   ├── configure.sh          # NixOS configuration
│   └── install.sh            # System installation
├── modules/                  # NixOS modules
│   ├── kiosk-base.nix        # Main kiosk configuration
│   └── kiosk/                # Modular kiosk components
│       ├── desktop/          # Display manager & window manager
│       ├── user/             # User management
│       ├── autostart/        # Startup applications
│       └── system/           # System settings
├── hosts/                    # Host-specific configurations
└── flake.nix                 # Nix flake definition
```

## 🎨 Desktop Environment

The kiosk system includes:
- **LightDM** display manager (optional)
- **Openbox** window manager
- **Tint2** panel with taskbar, system tray, and clock
- **Firefox** in kiosk mode
- **Comprehensive logging** for debugging

## ⚠️ Important Notes

- **Data Loss Warning**: The deployment will destroy all data on the selected disk
- **Hardware Requirements**: EFI-compatible system required
- **Network**: Internet connection required for NixOS installation
- **Backup**: Always backup important data before deployment

## 🔍 Troubleshooting

Check these log files for debugging:
- `/tmp/openbox-autostart.log` - Openbox startup
- `/tmp/tint2.log` - Tint2 panel
- `/tmp/firefox.log` - Firefox kiosk mode

## 📝 Examples

### Deploy to NVMe disk with custom settings
```bash
DISK=/dev/nvme0n1 \
HOSTNAME=production-kiosk \
KIOSK_USER=operator \
KIOSK_URL=https://factory.local \
TIMEZONE=America/New_York \
./simple-deploy.sh
```

### Deploy to SATA disk with minimal configuration
```bash
DISK=/dev/sda ./simple-deploy.sh
```

### Deploy with all custom settings
```bash
DISK=/dev/nvme0n1 \
HOSTNAME=shop-kiosk \
KIOSK_USER=staff \
KIOSK_PASSWORD=secure123 \
TIMEZONE=Europe/London \
LOCALE=en_GB.UTF-8 \
KIOSK_URL=https://shop.local \
BOOT_SIZE=1GB \
SWAP_SIZE=4GB \
./simple-deploy.sh
```
