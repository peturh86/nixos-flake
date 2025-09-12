# Kiosk Modules

This directory contains modular NixOS configurations for the kiosk system, organized by responsibility.

## 📁 Structure

```
kiosk/
├── desktop/          # Display manager, window manager, and panel
│   ├── default.nix   # X11, LightDM, Openbox configuration
│   ├── packages.nix  # Desktop environment packages
│   └── tint2.nix     # Tint2 panel configuration
├── user/             # User management and authentication
│   └── default.nix   # Kiosk user creation and autologin
├── autostart/        # Startup scripts and applications
│   └── default.nix   # Openbox autostart and Firefox kiosk
└── system/           # System-wide settings and services
    └── default.nix   # Networking, boot loader, SSH, etc.
```

## 🎯 Responsibilities

### Desktop (`desktop/`)
- **Display Manager**: LightDM configuration and autologin
- **Window Manager**: Openbox setup and session management
- **Panel**: Tint2 configuration and theming
- **Packages**: Desktop environment tools and utilities

### User (`user/`)
- **User Creation**: Kiosk user setup with proper permissions
- **Authentication**: Password configuration and group membership
- **Autologin**: Console and graphical autologin setup

### Autostart (`autostart/`)
- **Openbox Startup**: Background setting and initial configuration
- **Panel Launch**: Tint2 startup (when enabled)
- **Application Launch**: Firefox kiosk mode startup
- **Logging**: Comprehensive startup logging for debugging

### System (`system/`)
- **Networking**: NetworkManager and SSH configuration
- **Boot Loader**: systemd-boot setup for EFI systems
- **Localization**: Timezone, locale, and keyboard settings
- **System Services**: Core system services and state version

## 🔧 Configuration Options

All configuration options are available through `services.kiosk.*`:

```nix
services.kiosk = {
  # User settings
  user = "kiosk";
  password = "";
  extraGroups = [ "wheel" "networkmanager" ];
  autologin = true;

  # Desktop settings
  enableLightDM = true;
  enableTint2 = true;

  # Application settings
  kioskUrl = "https://factory-app.local";

  # System settings
  timeZone = "UTC";
  locale = "en_US.UTF-8";
  keyMap = "us";
};
```

## 🚀 Usage

The main `kiosk-base.nix` imports all sub-modules automatically. Individual modules can also be imported separately for custom configurations:

```nix
imports = [
  ./kiosk/user/default.nix
  ./kiosk/desktop/default.nix
  # ... other modules as needed
];
```

## 🔍 Debugging

Each module includes comprehensive logging:
- **Openbox**: `/tmp/openbox-autostart.log`
- **Tint2**: `/tmp/tint2.log`
- **Firefox**: `/tmp/firefox.log`

Check these logs for troubleshooting startup issues.
