<!-- markdownlint-disable MD033 MD041 -->

<p align="center">
    <img
        src="https://img.shields.io/badge/Debian%20setup%20scripts-reproducible%20automation-A80030?style=for-the-badge&logo=debian&logoColor=white"
        alt="Debian-branded badge: reproducible workstation automation"
    />
</p>

<h1 align="center">Debian Setup Scripts</h1>

<p align="center"><strong>Production-style Bash provisioning for standardized developer workstations.</strong></p>

<p align="center">
    Split <strong>install</strong> and <strong>configuration</strong> flows, audited helper patterns, submodule-backed dotfiles, and CI you can anchor release gates on—whether you onboard one laptop or fifty.
</p>

<p align="center">
    <a href="./LICENSE"><img src="https://img.shields.io/github/license/garretpatten/debian-setup-scripts?style=flat-square" alt="License: MIT" /></a>
    <a href="https://www.debian.org/"
        ><img src="https://img.shields.io/badge/platform-Debian%2012%2B-A80030?style=flat-square&logo=debian&logoColor=white" alt="Debian 12 (Bookworm) or newer"
    /></a>
    <img src="https://img.shields.io/badge/shell-bash-black?style=flat-square&logo=gnu-bash&logoColor=white" alt="Shell: Bash" />
    <img src="https://img.shields.io/badge/infra-APT%20%2B%20Flatpak-orange?style=flat-square&logo=debian&logoColor=white" alt="Package flows: APT and Flatpak" />
</p>

<p align="center">
    <a href="https://github.com/garretpatten/debian-setup-scripts/actions/workflows/test-runner.yaml"
        ><img src="https://img.shields.io/github/actions/workflow/status/garretpatten/debian-setup-scripts/test-runner.yaml?branch=master&label=Debian%20CI&logo=github&style=flat-square" alt="Test runner workflow status"
    /></a>
    <a href="https://github.com/garretpatten/debian-setup-scripts/actions/workflows/quality-checks.yaml"
        ><img src="https://img.shields.io/github/actions/workflow/status/garretpatten/debian-setup-scripts/quality-checks.yaml?branch=master&label=quality&logo=github&style=flat-square" alt="Quality checks workflow status"
    /></a>
    <a href="https://github.com/garretpatten/debian-setup-scripts/actions/workflows/security-guardrails.yaml"
        ><img src="https://img.shields.io/github/actions/workflow/status/garretpatten/debian-setup-scripts/security-guardrails.yaml?branch=master&label=security&logo=github&style=flat-square" alt="Security guardrails workflow status"
    /></a>
</p>

<p align="center">
    ✓ Modular orchestration &nbsp;
    ✓ Split install/config bundles &nbsp;
    ✓ Linted Bash + docs in PR &nbsp;
    ✓ Idempotent, rerunnable phases
</p>

<!-- markdownlint-enable MD033 MD041 -->

---

## Overview

Debian Setup Scripts automate a **baseline engineering stack**: security tooling, shells and terminals,
development runtimes (Node, Docker, Neovim, and peers), GNOME ergonomics where a desktop session exists,
and a pinned **dotfiles** submodule for editor and tmux parity across machines. Scripts are tuned for clarity in
reviews and predictable behavior in a **Debian Bookworm** container CI job.

## ✨ Features

- **🔧 Automated Setup**: Complete system configuration with a single command
- **🛡️ Security First**: Built-in security tools, firewall configuration, and
  safe installation practices
- **⚡ Optimized Performance**: Batch installations and smart caching for
  faster execution
- **🔄 Idempotent**: Safe to run multiple times without issues
- **📝 Comprehensive Logging**: Detailed progress tracking and error reporting
- **🎯 Modular Design**: Run individual components or orchestrators (`master.sh`)
- **⚙️ Install vs configuration**: Category automation is split between
  `src/scripts/install/` (APT/Flatpak, third-party installers, clones) and
  `src/scripts/config/` (`gsettings`, home layout, UFW policy, submodule
  dotfiles, default shell). Use `npm run installs`, `npm run config`, or `npm run all`,
  or invoke `run-install.sh` / `run-config.sh` directly.

## 🚀 Quick Start

### Prerequisites

- Debian 12 (Bookworm) or newer
- Internet connection
- Sudo privileges

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/garretpatten/debian-setup-scripts
cd debian-setup-scripts
```

1. **Install Node deps** (optional; enables `npm run` shortcuts below)

```bash
npm install
```

1. **Update submodules** (for dotfiles)

```bash
git submodule update --init --remote --recursive src/dotfiles/
```

1. **Make scripts executable**

```bash
chmod +x src/scripts/*.sh \
  src/scripts/install/*.sh \
  src/scripts/config/*.sh
```

1. **Run the complete setup**

```bash
npm run all
# or:
./src/scripts/master.sh
```

### npm scripts

| Command            | Runs                                                                                                       |
| ------------------ | ---------------------------------------------------------------------------------------------------------- |
| `npm run all`      | Full provisioning (`master.sh`): installs interleaved with configuration (see execution flow below).       |
| `npm run installs` | Install bundle only (`run-install.sh`): packages and installers—no GNOME/dotfiles/config steps.            |
| `npm run config`   | Configuration bundle only (`run-config.sh`): defaults, home layout, UFW defaults, submodule copies, shell. |

Bash equivalents:

```bash
bash src/scripts/run-install.sh
bash src/scripts/run-config.sh
bash src/scripts/master.sh
```

Use **`npm run config`** when packages are already present but GNOME/dotfiles paths should be refreshed after updating the submodule.

### Granular scripts

Each category exists as **install** and/or **configuration** scripts (paths from repo root):

```bash
bash src/scripts/install/cli.sh
bash src/scripts/install/dev.sh

bash src/scripts/config/system-config.sh      # GNOME + unattended APT + sysctl (no extra packages besides unattended-upgrades)
bash src/scripts/config/organizeHome.sh
bash src/scripts/config/dev.sh               # Editors / XDG subtree + Git identity
bash src/scripts/config/security.sh           # UFW defaults (requires `install/security.sh` first)
bash src/scripts/config/shell.sh              # Submodule shell + terminal dotfiles (`~/.config/tmux`, etc.)
```

Prefer the orchestrators so ordering stays consistent (for example **`config/security.sh`** after **`install/security.sh`**, **`config/shell.sh`** after **`install/shell.sh`**, and **`install/post-install.sh`** docker/UFW touchpoints ahead of **`config/shell.sh`** when running a full provisioning pass).

## Project structure

```text
debian-setup-scripts/
├── src/
│   ├── scripts/
│   │   ├── utils.sh
│   │   ├── master.sh          # Full run — interleaved installs + configuration
│   │   ├── run-install.sh      # APT/Flatpak/installers/post-install hooks only
│   │   ├── run-config.sh       # GNOME, home layout, firewall policy, dotfiles, shell
│   │   ├── install/
│   │   │   ├── pre-install.sh
│   │   │   ├── cli.sh
│   │   │   ├── media.sh
│   │   │   ├── productivity.sh
│   │   │   ├── dev.sh         # Languages, Docker, NeoVim APT, tooling (no submodule copies)
│   │   │   ├── security.sh    # Packages, Proton/VPN installs, clones (UFW separately)
│   │   │   ├── shell.sh       # Terminal packages, Ghostty installer, fonts, Oh My Posh
│   │   │   └── post-install.sh
│   │   └── config/
│   │       ├── system-config.sh
│   │       ├── organizeHome.sh
│   │       ├── dev.sh         # submodule `config/*` subsets + Git defaults + Vimrc + VS Code user settings path
│   │       ├── security.sh    # UFW deny/enable + SSH
│   │       └── shell.sh       # Ghostty/tmux/modular ~/.config paths, ~/.dotfiles_path, chsh if needed
│   ├── dotfiles/              # submodule
│   └── assets/
└── ...
```

### Execution flow (`master.sh`)

1. **`install/pre-install.sh`** — essential APT packages, timezone if still UTC
2. **`config/system-config.sh`** — GNOME defaults (when schemas/bus exist), unattended upgrades sysctl/guest login tweaks
3. **`config/organizeHome.sh`** — home folders and permissions
4. **`install/cli.sh`** — Flatpak, **`btop`**, **`fastfetch`** (APT or backports), other CLI APT packages, Flathub
5. **`install/media.sh`**, **`install/productivity.sh`**
6. **`install/dev.sh`** — NodeSource Node, NVM, Docker CE (Debian repo), Neovim APT, Postman Flatpak, `semgrep`, `src` CLI
7. **`config/dev.sh`** — copy editor/XDG subsets from **`src/dotfiles/config/`**, Git globals, Vimrc path, VS Code `settings.json` when missing
8. **`install/security.sh`** — UFW/OpenVPN APT, Proton tooling, Signal, pen-test packages, clones under `~/Hacking`
9. **`config/security.sh`** — **`ufw` defaults** after the package exists
10. **`install/shell.sh`** — Zsh/Tmux/fonts/Ghostty/Oh My Posh installers
11. **`install/post-install.sh`** — `apt-get upgrade`/docker group/banner (**UFW `--force enable` stays best-effort here too**)
12. **`config/shell.sh`** — **`home/`** dotfiles (**`home/.tmux.conf`** pulls in **`~/.config/tmux/includes/base.conf`** once **`config/tmux/`** lands under **`~/.config`**), **`~/.dotfiles_path`** for the Linux zsh snippet in the dotfiles submodule, `chsh` when possible

---

## 📋 What gets installed vs configured

The lists below mirror the **`install/`** and **`config/`** split; open each file for exact commands.

### **`install/` bundle**

#### 🧰 **Bootstrap** (`install/pre-install.sh`)

- APT housekeeping; toolchain packages (`git`, `curl`, `wget`, `gnupg`, etc.).
- Sets timezone away from **`UTC`** toward **`America/New_York`** when still UTC.

#### 🛠️ **CLI Tools** (`install/cli.sh`)

- Flatpak + Flathub.
- Essentials: **`bat`**, **`curl`**, **`eza`**, **`fastfetch`** (APT or backports),
  **`fd-find`**, **`git`**, **`htop`**, **`jq`**, **`ripgrep`**, **`vim`**, **`wget`**.
- **`btop`**: APT on Debian 12+.

#### 💻 **Development packages** (`install/dev.sh`)

- Node.js **`nodejs`** via NodeSource (**24.x** branch), NVM install script when missing,
  **`@vue/cli`** globally, **`python3`** toolchain, Docker CE repos + Compose plugin,
  **`neovim`**, **`gh`**, **`shellcheck`**, **`semgrep`** (pip), **`src`** (Sourcegraph), Postman (**Flatpak**).

#### 🎬 **Media** (`install/media.sh`)

Brave, VLC, Spotify (**Flatpak**), multimedia codec packages, **`ttf-mscorefonts-installer`**.

#### 📊 **Productivity** (`install/productivity.sh`)

LibreOffice, Zoom (`.deb` from zoom.us), Standard Notes (**Flatpak**), KeePassXC, Redshift, Flameshot, Balena Etcher AppImage.

#### 🔒 **Security packages & payloads** (`install/security.sh`)

- **`ufw`** and **`openvpn`** APT packages (rules live in **`config/security.sh`**).
- Proton VPN desktop meta-package, Signal desktop APT repo, **`nmap`**, **`exiftool`**, **OWASP ZAP** (APT **`zaproxy`**), Proton Pass desktop + CLI installers.
- Optionally clones **`PayloadsAllTheThings`** / **`SecLists`** into **`~/Hacking`** (directory expected from **`config/organizeHome.sh`** in a typical full run).

#### 🐚 **Shell tooling** (`install/shell.sh`)

Zsh plugins, **`tmux`**, Meslo/Fira/powerline APT fonts plus optional Nerd Font drop, Ghostty via **`debian.griffo.io`** APT repo,
user Oh My Posh binary + theme stash under **`/usr/share/oh-my-posh/themes`** when empty.

#### 🏁 **Post maintenance** (`install/post-install.sh`)

`apt-get upgrade`, Docker systemd + **`docker`** group enrollment, **`ufw`** best-effort enable, and a completion banner (`src/assets/debian.txt`, Debian ASCII derived from [fastfetch](https://github.com/fastfetch-cli/fastfetch) with color tokens removed for plain terminals).

### **`config/` bundle**

#### 🏠 **Home layout** (`config/organizeHome.sh`)

- Drops empty **`Music`/`Public`/`Templates`** where applicable.
- Creates **`~/Projects`**, **`~/Hacking`**, **`~/AppImages`**, **`~/Projects/opensource`** / **`personal`**, adjusts **`Scripts`/`Hacking`** permissions.

#### ⚙️ **Desktop & unattended APT** (`config/system-config.sh`)

- **GNOME** (logged-in Desktop / D-Bus): dark mode, animations, clocks, scrolling, Nautilus, screenshots, Dash to Dock (**when schema exists**), Night Light, lock/privacy, search providers.
- Installs **`unattended-upgrades`** and drops **`20auto-upgrades`** when missing.
- **sudo**: **`AllowGuest=false`** hint in **`gdm3`**, tame Apport, **`logind`** lid snippet, sysctl TCP keepalive drop-in.

Minimal/CI runners without GNOME skip **`gsettings`** safely.

#### 💻 **Editor & Git prefs** (`config/dev.sh`)

- Copies a **focused set** from **`src/dotfiles/config/`** into **`~/.config/`**: **`nvim`**, **`btop`**, **`fastfetch`**, **`alacritty`**, **`kitty`**, **`zellij`** (trees skipped when **`~/.config/<app>/`** already exists).
- Copies **`home/.vimrc`** and VS Code **`User/settings.json`** when missing (**`~/.config/Code/User`** on Linux).
- Seeds **`~/.gitconfig`** **only when absent** with global credential helper + identity defaults matching the legacy script behavior.

#### 🔒 **UFW posture** (`config/security.sh`)

`ufw reset`, deny incoming / allow outgoing, allow **`ssh`**, force enable (expects **`install/security.sh`** to have installed \*\*`ufw` first`).

#### 🐚 **Shell dotfiles & terminal configs** (`config/shell.sh`)

- Copies **`Ghostty`**, **`oh-my-posh`**, and the **modular `config/tmux/`** subtree into **`~/.config`** (tmux **`source-file`** layout — see **`src/dotfiles/README.md`**).
- Copies **`home/.tmux.conf`**, **`home/.zshrc`**, optional **`home/.bashrc`** when missing.
- Maintains **`~/.dotfiles_path`** so **`home/.zshrc`** resolves **`DOTFILES`**; runs **`chsh`** when possible.

**Full symlink mirror**: from **`src/dotfiles`**, **`./setup.sh --link-xdg-config`** installs every **`config/<app>/`** tree under **`$XDG_CONFIG_HOME`** ([dotfiles README](https://github.com/garretpatten/dotfiles/blob/master/README.md)). Parent **`config/`** scripts still provision the subset above for first-touch machines.

Other runtime actions people often treat as configuration still live with installs for ordering reasons: **`install/post-install.sh`** enables Docker/`ufw`; **`npm run installs`** omits **`config/`** entirely so run **`npm run config`** afterward for dotfiles parity.

## 📊 Monitoring & Logs

After installation, check:

- **Error Log**: `setup_errors.log` - Centralized error tracking
- **Summary Report**: `setup_summary.txt` - Installation status overview
- **Console Output**: Real-time progress with color-coded messages

## ⚠️ Post-Installation Notes

1. **Restart Required**: Log out and back in for shell and group changes
1. **GNOME / desktop**: Run provisioning from a terminal inside your session, or
   expect a logout/reboot for some changes. **`system-config.sh`** does not restart
   **`systemd-logind`** while a graphical session is active (restarting it logs you out).
   Lid-switch settings from a first-time drop-in apply after reboot if you were logged in.
1. **GNOME / gsettings**: Night Light and other preferences apply when the script runs
   with a live D-Bus session (`gsettings_ok`); re-login if you ran headless first.
1. **Docker**: User added to docker group (logout required for effect)
1. **Firewall**: UFW enabled with SSH access allowed
1. **Night Light vs Redshift**: If you use GNOME Night Light from
   `config/system-config.sh`, disable or uninstall Redshift from `install/productivity.sh` to
   avoid conflicting color temperature
1. **Manual Setup**: Some applications (like 1Password, ProtonVPN) may require
   additional configuration

## 🔍 Troubleshooting

### Common Issues

**Script fails with permission errors:**

```bash
# Ensure scripts are executable
chmod +x src/scripts/*.sh \
  src/scripts/install/*.sh \
  src/scripts/config/*.sh
```

**Package installation fails:**

```bash
# Update package lists manually
sudo apt update
# Then re-run the script
```

**Docker commands require sudo:**

```bash
# Log out and back in, or run:
newgrp docker
```

**Shell doesn't change to Zsh:**

```bash
# Manually change shell
chsh -s $(which zsh)
# Then log out and back in
```

**Black screen, logout during setup, or frozen terminal after login:**

Older runs restarted **`systemd-logind`** on every **`system-config.sh`** invocation,
which ends the GNOME session. If the default shell is Zsh and the terminal hangs,
switch to a TTY (**Ctrl+Alt+F3**), then restore Bash or fix **`~/.zshrc`** (for example
comment out **`pass-cli`** / Proton Pass lines until Pass is configured):

```bash
chsh -s /bin/bash
```

### Getting Help

- Check `setup_errors.log` for detailed error information
- Review `setup_summary.txt` for installation status
- Ensure you're running on a supported Debian version (12+)
- Verify internet connection for package downloads

## 🛡️ Security Features

- **Hash verification** for all downloaded packages
- **GPG key verification** for third-party repositories
- **Automatic firewall configuration** with secure defaults
- **Safe temporary file handling** with automatic cleanup
- **Principle of least privilege** for directory permissions

## Community

| Resource                                | Use                                         |
| --------------------------------------- | ------------------------------------------- |
| [Code of Conduct](./CODE_OF_CONDUCT.md) | Expected behavior in issues and PRs         |
| [Contributing](./CONTRIBUTING.md)       | Branching, checks, submodule notes          |
| [Security policy](./SECURITY.md)        | Vulnerability reporting (not public issues) |

## Maintainers

[@garretpatten](https://github.com/garretpatten/).

Use the [issue templates](./.github/ISSUE_TEMPLATE/) for bugs and enhancements.

## License

This project is licensed under the [MIT License](./LICENSE).
