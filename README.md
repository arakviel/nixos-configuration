# Arakviel's NixOS Configuration

Modern NixOS configuration with GNOME desktop, development tools, and automated Docker services.

## 🚀 Quick Installation

### Prerequisites
- UEFI system
- Target disk: `/dev/nvme1n1` (all data will be erased)
- Internet connection

### Automated Installation (Recommended)

1. **Clone configuration**
```bash
sudo mkdir -p /mnt/etc/nixos
sudo git clone https://github.com/arakviel/nixos-configuration.git /mnt/etc/nixos
```

2. **Auto-partition with Disko**
```bash
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko /mnt/etc/nixos/disko-config.nix
```

3. **Install system**
```bash
sudo nixos-install --flake /mnt/etc/nixos#arakviel-pc
```

4. **Reboot**
```bash
sudo reboot
```

## ⌨️ Keyboard Shortcuts

### Workspaces
- `Ctrl + Alt + Left/Right` - Switch between workspaces
- `Super + Page Up/Down` - Switch between workspaces
- `Super + Home/End` - Go to first/last workspace
- `Ctrl + Shift + Alt + Left/Right` - Move window to workspace

### Window Management
- `Alt + F4` - Close window
- `Super + Up` - Maximize window
- `Super + h` - Minimize window
- `Alt + Tab` / `Super + Tab` - Switch applications
- `Alt + F7/F8` - Move/resize window

### Applications
- `Super + 1-9` - Switch to application in dock
- `Super + Ctrl + 1-9` - Open new window of application
- `Super + a` - Show all applications
- `Super + s` - Quick settings

### Screenshots
- `Print` - Screenshot UI
- `Shift + Print` - Take screenshot
- `Alt + Print` - Screenshot active window
- `Ctrl + Shift + Alt + R` - Screen recording

### Language Switching
- `Super + Space` - Switch keyboard layout (US/UA/RU)
- `Shift + Super + Space` - Switch layout backward

### Terminal (Kitty)
- `Ctrl + C` - Copy or interrupt
- `Ctrl + F` - Search in terminal
- `Ctrl + Plus/Minus` - Zoom in/out
- `Ctrl + 0` - Reset zoom
- `Page Up/Down` - Scroll

### VPN Management
- `nmcli connection up <VPN_NAME>` - Connect to VPN
- `nmcli connection down <VPN_NAME>` - Disconnect from VPN
- `nmcli connection show --active` - Show active connections

## 🛠️ Common NixOS Commands

### System Management
```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#arakviel-pc

# Test configuration without switching
sudo nixos-rebuild test --flake .#arakviel-pc

# Build configuration
sudo nixos-rebuild build --flake .#arakviel-pc

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Package Management
```bash
# Search packages
nix search nixpkgs <package-name>

# Install package temporarily
nix shell nixpkgs#<package-name>

# Run package without installing
nix run nixpkgs#<package-name>

# Update flake inputs
nix flake update

# Show flake info
nix flake show
```

### Garbage Collection
```bash
# Collect garbage
sudo nix-collect-garbage

# Delete old generations (older than 7 days)
sudo nix-collect-garbage --delete-older-than 7d

# Optimize store
sudo nix-store --optimise
```

### Development
```bash
# Enter development shell
nix develop

# Create flake template
nix flake init

# Check flake
nix flake check
```

## 📦 Included Software

### Desktop Environment
- GNOME with extensions (Dash to Dock, Vitals, Blur My Shell)
- Kitty terminal with Fish shell
- Starship prompt

### Development Tools
- Languages: PHP, C#, Java, JavaScript, Python, C++
- Editors: VSCode, Neovim
- Tools: Docker, Git, Postman, Azure CLI
- JetBrains Toolbox

### Applications
- Browsers: Chrome, Firefox, Edge
- Communication: Telegram, Discord, Slack
- Productivity: Obsidian, OnlyOffice
- Security: ProtonVPN, Proton Pass

### Services
- Docker containers: PostgreSQL, MySQL, MSSQL, Redis, RabbitMQ, Portainer
- Jenkins CI/CD
- LibVirt virtualization
- OpenVPN support with NetworkManager integration

## 🔧 Configuration Structure

```
├── flake.nix              # Main flake configuration
├── disko-config.nix       # Disk partitioning
├── .gitignore             # NixOS-specific gitignore rules
├── templates/             # Configuration templates
│   └── example.ovpn.template # VPN configuration template
└── modules/
    ├── configuration.nix  # Main system config
    ├── system.nix         # Core system settings & utilities
    ├── boot.nix           # Boot configuration
    ├── hardware.nix       # Hardware settings
    ├── networking.nix     # Network and firewall
    ├── services.nix       # System services
    ├── users.nix          # User accounts
    ├── desktop.nix        # GNOME configuration
    ├── fonts.nix          # Font configuration
    ├── development.nix    # Development tools & languages
    ├── shell.nix          # Shell configuration (Fish, Starship)
    ├── virtualization.nix # Docker & LibVirt
    ├── vpn.nix            # VPN configuration
    ├── docker-services.nix # Docker containers
    └── home.nix           # User-specific settings
```

---

## 🔧 Manual Installation (Alternative)

### 1. Prepare Disk
```bash
# Wipe disk
sudo wipefs -a /dev/nvme1n1
sudo parted /dev/nvme1n1 -- mklabel gpt

# Create partitions
sudo parted /dev/nvme1n1 -- mkpart primary fat32 1MiB 1GiB
sudo parted /dev/nvme1n1 -- set 1 esp on
sudo parted /dev/nvme1n1 -- mkpart primary ext4 1GiB 936.9GB
sudo parted /dev/nvme1n1 -- mkpart primary linux-swap 936.9GB 953.9GB # 16GB swap partition

# Format partitions
sudo mkfs.vfat -F 32 /dev/nvme1n1p1
sudo mkfs.ext4 -L nixos /dev/nvme1n1p2
sudo mkswap /dev/nvme1n1p3
```

### 2. Mount Filesystems
```bash
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme1n1p1 /mnt/boot
sudo swapon /dev/nvme1n1p3
```

### 3. Generate Hardware Config
```bash
sudo nixos-generate-config --root /mnt
```

### 4. Clone and Install
```bash
sudo mkdir -p /mnt/etc/nixos
sudo git clone https://github.com/arakviel/nixos-configuration.git /mnt/etc/nixos
sudo nixos-install --flake /mnt/etc/nixos#arakviel-pc
```

### 5. Cleanup and Reboot
```bash
sudo umount -R /mnt
sudo reboot
```

## 🔐 VPN Configuration

### Adding OpenVPN Configuration

1. **Place your .ovpn file** in `/etc/openvpn/client/`
2. **Import via NetworkManager:**
   ```bash
   nmcli connection import type openvpn file /path/to/your.ovpn
   ```
3. **Configure split-tunneling** (optional):
   ```bash
   nmcli connection modify <VPN_NAME> ipv4.never-default yes
   ```
4. **Connect:**
   ```bash
   nmcli connection up <VPN_NAME>
   ```

### VPN File Security

**✅ Safe alternatives:**
- Use environment variables for credentials
- Store files in `/etc/openvpn/client/` (excluded from Git)
- Use NixOS secrets management (agenix, sops-nix)
- Create template files with placeholders

**📋 Setup Instructions:**
1. Copy `templates/example.ovpn.template` to your .ovpn file
2. Replace placeholders with actual values
3. Place in `/etc/openvpn/client/`
4. Import via NetworkManager

## 🔒 Security & Best Practices

### Gitignore Protection
This configuration includes comprehensive `.gitignore` rules for NixOS projects:
- **Sensitive files**: VPN configs, SSH keys, certificates
- **Build artifacts**: `result/`, `*.iso`, VM images
- **Hardware configs**: Machine-specific `hardware-configuration.nix`
- **Development files**: Editor configs, cache files
- **Secrets**: Age/sops files, environment variables

### Safe Configuration Management
- Use templates for sensitive configurations
- Store secrets in `/etc/` directories (excluded from Git)
- Consider using `agenix` or `sops-nix` for production secrets
- Never commit private keys or passwords

## 📝 Notes

- **UEFI Required**: This configuration uses GRUB with EFI support
- **Disk Warning**: All data on target disk will be erased
- **Network**: Ensure stable internet connection during installation
- **Passwords**: Set root password during installation process
