<!-- markdownlint-disable MD013 MD033 MD041 -->

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
  `src/scripts/install/` (APT, third-party installers, repo clones) and
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
  src/scripts/install/**/*.sh \
  src/scripts/config/*.sh \
  src/scripts/config/**/*.sh
```

1. **Run the complete setup**

```bash
npm run all
# or:
./src/scripts/master.sh
```

### npm scripts

| Command               | Runs                                     |
| --------------------- | ---------------------------------------- |
| `npm run all`         | Full provisioning (`master.sh`).         |
| `npm run install:cli` | CLI-only install (`run-install.sh cli`). |
| `npm run install:all` | Full install (`run-install.sh all`).     |
| `npm run installs`    | Alias for `npm run install:all`.         |
| `npm run config`      | Config bundle only (`run-config.sh`).    |

Bash equivalents:

```bash
bash src/scripts/run-install.sh cli # CLI-only install
bash src/scripts/run-install.sh all # full install (default)
bash src/scripts/run-config.sh      # config only
bash src/scripts/master.sh          # install + config
```

The `install/all.sh` orchestrator accepts `--cli` to skip desktop apps, media,
productivity packages, `.deb` GUI installers, and snap installs.

CI runs four jobs in a `debian:bookworm` container:

- `test-cli`: `run-install.sh cli` then `validate-installs-cli.sh`
- `test-config`: `run-config.sh` then `validate-config-only.sh`
- `test-full`: `run-install.sh all` then `validate-installs.sh`
- `test-master`: `master.sh` then `validate.sh`

Use **`npm run config`** when packages are already present but GNOME/dotfiles paths should be refreshed after updating the submodule.

### Granular scripts

Each category exists as **install** and/or **configuration** scripts (paths from repo root):

```bash
# Install orchestrators and leaf scripts
bash src/scripts/install/cli.sh
bash src/scripts/install/all.sh
bash src/scripts/install/all.sh --cli
bash src/scripts/install/apps/chrome.sh
bash src/scripts/install/dev/nvm.sh
bash src/scripts/install/shell/oh-my-posh.sh

# Config orchestrators and leaf scripts
bash src/scripts/config/system/all.sh
bash src/scripts/config/home/organize-home.sh
bash src/scripts/config/dev/all.sh
bash src/scripts/config/security/ufw-rules.sh
bash src/scripts/config/shell/all.sh
```

Prefer the orchestrators so ordering stays consistent (for example `config/security/ufw-rules.sh`
after the install phase has placed `ufw`, and `config/shell/all.sh` after install shell leaf scripts
have installed zsh and oh-my-posh).

## Project structure

```text
debian-setup-scripts/
├── src/
│   ├── scripts/
│   │   ├── master.sh              # Full run — installs then configuration
│   │   ├── run-install.sh          # Install orchestrator entrypoint
│   │   ├── run-config.sh           # Config orchestrator entrypoint
│   │   ├── install/
│   │   │   ├── all.sh              # Full install orchestrator (`--cli` for CLI-only)
│   │   │   ├── cli.sh              # Thin wrapper that runs `all.sh --cli`
│   │   │   ├── apps/
│   │   │   │   ├── chrome.sh
│   │   │   │   ├── etcher.sh
│   │   │   │   ├── hacking-repos.sh
│   │   │   │   ├── pass-cli.sh
│   │   │   │   ├── proton-pass.sh
│   │   │   │   ├── protonvpn-install.sh
│   │   │   │   ├── snaps.sh
│   │   │   │   └── ufw-docker.sh
│   │   │   ├── dev/
│   │   │   │   ├── cursor-cli.sh
│   │   │   │   ├── git-credential-libsecret.sh
│   │   │   │   ├── go.sh
│   │   │   │   ├── language-servers.sh
│   │   │   │   ├── nvm.sh
│   │   │   │   ├── ollama.sh
│   │   │   │   ├── ruby-gems.sh
│   │   │   │   ├── rustup.sh
│   │   │   │   ├── semgrep.sh
│   │   │   │   └── vue-cli.sh
│   │   │   ├── packages/
│   │   │   │   └── *.packages    # One-per-line apt package lists
│   │   │   ├── post-install/
│   │   │   │   ├── apt-maintain.sh
│   │   │   │   ├── completion-banner.sh
│   │   │   │   ├── docker-service.sh
│   │   │   │   └── tldr-cache.sh
│   │   │   ├── preflight/
│   │   │   │   ├── apt-maintain.sh
│   │   │   │   ├── essentials.sh
│   │   │   │   └── timezone.sh
│   │   │   ├── repos/
│   │   │   │   ├── manifest
│   │   │   │   └── setup.sh
│   │   │   ├── shell/
│   │   │   │   ├── ghostty.sh
│   │   │   │   ├── meslo-nerd-font.sh
│   │   │   │   └── oh-my-posh.sh
│   │   │   └── snaps.txt
│   │   ├── lib/
│   │   │   ├── apt-maintain.sh
│   │   │   ├── apt-packages.sh
│   │   │   ├── apt-repo-add.sh
│   │   │   ├── apt-repos.sh
│   │   │   ├── dotfiles-install.sh
│   │   │   ├── env.sh
│   │   │   ├── git-submodules.sh
│   │   │   ├── gnome-session.sh
│   │   │   ├── parallel.sh
│   │   │   ├── run.sh
│   │   │   ├── snap-install.sh
│   │   │   └── zsh-login.sh
│   │   └── config/
│   │       ├── all.sh
│   │       ├── dev/
│   │       │   ├── all.sh
│   │       │   └── gitconfig.sh
│   │       ├── dotfiles.manifest
│   │       ├── dotfiles.sh
│   │       ├── home/
│   │       │   ├── all.sh
│   │       │   └── organize-home.sh
│   │       ├── security/
│   │       │   ├── all.sh
│   │       │   └── ufw-rules.sh
│   │       ├── shell/
│   │       │   ├── all.sh
│   │       │   ├── chsh-zsh.sh
│   │       │   └── dotfiles-zshrc.sh
│   │       └── system/
│   │           ├── all.sh
│   │           ├── gnome-gsettings.sh
│   │           ├── screenshots-directory.sh
│   │           ├── system-policy.sh
│   │           └── unattended-upgrades.sh
│   ├── dotfiles/                  # submodule
│   └── assets/
└── ...
```

### Execution flow (`master.sh`)

1. **`install/preflight/all.sh`** — essential APT packages, timezone if still UTC, contrib/non-free enablement
2. **`config/system/all.sh`** — GNOME defaults (when schemas/bus exist), screenshots dir, unattended upgrades, sysctl/guest login tweaks
3. **`config/home/all.sh`** — home folders and permissions
4. **`install/all.sh`** — package lists, third-party APT repos, dev/shell/app leaf scripts, `.deb` installers, post-install hooks
5. **`config/dev/all.sh`** — copy `src/dotfiles/config/` subtrees, Git globals, Vimrc path, VS Code `settings.json` when missing
6. **`config/security/all.sh`** — `ufw` defaults after the package exists
7. **`config/shell/all.sh`** — `home/` dotfiles, `~/.dotfiles_path` cache, `chsh` when possible

`run-install.sh` runs only the install phase; `run-config.sh` runs only the config phase.

### Validation scripts (`scripts/`)

| Script                     | Use with                                   |
| -------------------------- | ------------------------------------------ |
| `validate-installs-cli.sh` | After `run-install.sh cli`                 |
| `validate-installs.sh`     | After `run-install.sh all` or `master.sh`  |
| `validate-config-only.sh`  | After `run-config.sh`                      |
| `validate-config.sh`       | After `master.sh` or full install + config |
| `validate.sh`              | After `master.sh` (installs + config)      |

---

## 📋 What gets installed vs configured

The lists below mirror the **`install/`** and **`config/`** split; open each file for exact commands.

### **`install/` bundle**

#### 🧰 **Bootstrap** (`install/preflight/all.sh`)

- APT housekeeping; toolchain packages (`git`, `curl`, `wget`, `gnupg`, `lsb-release`, etc.).
- Sets timezone away from **`UTC`** toward **`America/New_York`** when still UTC.
- Enables **`contrib`/`non-free`/`non-free-firmware`** on sources lists when missing.

#### 🛠️ **CLI Tools** (`install/packages/base.packages`, `install/packages/shell.packages`)

- Essentials: **`bat`**, **`curl`**, **`eza`**, **`fastfetch`** (main archive or backports),
  **`fd-find`**, **`git`**, **`htop`**, **`jq`**, **`ripgrep`**, **`vim`**, **`wget`**, **`zoxide`**.
- **`btop`**, **`tealdeer`**, **`tree-sitter-cli`**.
- Zsh + plugins, **`tmux`**, Fira Code / Font Awesome fonts.

#### 💻 **Development packages** (`install/dev/`, `install/packages/`)

- Node.js **`nodejs`** via NodeSource (**24.x** branch), NVM install script when missing,
  **`@vue/cli`** globally.
- **`python3`** toolchain, Docker CE repos + Compose plugin, **`golang-go`**.
- **`neovim`**, **`gh`**, **`shellcheck`**, **`semgrep`** (pip), **`ollama`**, **`rustup`**, **`cursor`**.
- Language servers: npm LSPs, Lua LS, Ruby **`solargraph`**.

#### 🎬 **Media** (`install/packages/media.packages`, `install/packages/optional-desktop.packages`)

VLC, multimedia codec packages, **`ttf-mscorefonts-installer`**.

#### 📊 **Productivity** (`install/packages/productivity.packages`, `install/apps/`)

LibreOffice, Google Chrome (`.deb`), KeePassXC, Redshift, Flameshot, Balena Etcher (`.deb`).

#### 🔒 **Security packages & payloads** (`install/apps/`, `install/packages/`)

- **`ufw`** and **`openvpn`** APT packages (rules live in **`config/security/ufw-rules.sh`**).
- Proton VPN desktop meta-package, Signal desktop APT repo, **`nmap`**, **`exiftool`**, **OWASP ZAP** (snap), Proton Pass desktop + CLI installers.
- Optionally clones **`PayloadsAllTheThings`** / **`SecLists`** into **`~/Hacking`** (directory expected from **`config/home/organize-home.sh`** in a typical full run).

#### 🐚 **Shell tooling** (`install/shell/`)

Zsh plugins, **`tmux`**, Meslo Nerd Font drop, Ghostty via **`debian.griffo.io`** APT repo,
user Oh My Posh binary.

#### 🏁 **Post maintenance** (`install/post-install/all.sh`)

`apt-get autoremove`/autoclean, Docker systemd + **`docker`** group enrollment, `tldr` cache update,
and a completion banner (`src/assets/debian.txt`).

### **`config/` bundle**

#### 🏠 **Home layout** (`config/home/organize-home.sh`)

- Drops empty **`Music`/`Public`/`Templates`** where applicable.
- Creates **`~/Projects`**, **`~/Hacking`**, **`~/AppImages`**, **`~/Projects/opensource`** / **`personal`**, adjusts **`Scripts`/`Hacking`** permissions.

#### ⚙️ **Desktop & unattended APT** (`config/system/`)

- **GNOME** (logged-in Desktop / D-Bus): dark mode, animations, clocks, scrolling, Nautilus, screenshots, Dash to Dock (**when schema exists**), Night Light, lock/privacy, search providers.
- Installs **`unattended-upgrades`** and drops **`20auto-upgrades`** when missing.
- **sudo**: **`AllowGuest=false`** hint in **`gdm3`**, tame Apport, **`logind`** lid snippet, sysctl TCP keepalive drop-in.

Minimal/CI runners without GNOME skip **`gsettings`** safely.

#### 💻 **Editor & Git prefs** (`config/dev/all.sh`)

- Copies **`src/dotfiles/config/`** subtrees into **`~/.config/`** (skipped when **`~/.config/<app>/`** already exists).
- Copies **`home/.vimrc`** and VS Code **`User/settings.json`** when missing (**`~/.config/Code/User`** on Linux).
- Seeds **`~/.gitconfig`** **only when absent** with global credential helper + identity defaults.

#### 🔒 **UFW posture** (`config/security/ufw-rules.sh`)

`ufw reset`, deny incoming / allow outgoing, allow **`ssh`**, force enable (expects the install phase to have installed **`ufw`** first).

#### 🐚 **Shell dotfiles & terminal configs** (`config/shell/`)

- Copies **`home/.tmux.conf`**, **`home/.zshrc`**, optional **`home/.bashrc`** when missing.
- Maintains **`~/.dotfiles_path`** so **`home/.zshrc`** resolves **`DOTFILES`**; runs **`chsh`** when possible.

**Full mirror**: from **`src/dotfiles`**, **`./setup.sh --link-xdg-config`** installs every **`config/<app>/`** tree under **`$XDG_CONFIG_HOME`** ([dotfiles README](https://github.com/garretpatten/dotfiles/blob/master/README.md)). Parent **`config/`** scripts still provision the subset above for first-touch machines.

Other runtime actions people often treat as configuration still live with installs for ordering reasons: `install/post-install/docker-service.sh` enables Docker/`ufw`; `npm run installs` omits `config/` entirely so run `npm run config` afterward for dotfiles parity.

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
  src/scripts/install/**/*.sh \
  src/scripts/config/*.sh \
  src/scripts/config/**/*.sh
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
