#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

update_apt_cache

# Node.js + npm from NodeSource (https://github.com/nodesource/distributions)
NODE_MAJOR=24
nodesource_key="/etc/apt/keyrings/nodesource.gpg"
nodesource_list="/etc/apt/sources.list.d/nodesource.list"

install_apt_packages "ca-certificates" "curl" "gnupg"

sudo mkdir -p /etc/apt/keyrings 2>>"$ERROR_LOG_FILE" || true

if [[ ! -f "$nodesource_key" ]]; then
    curl -fsSL --connect-timeout 30 --max-time 300 https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key 2>>"$ERROR_LOG_FILE" | \
        sudo gpg --dearmor -o "$nodesource_key" 2>>"$ERROR_LOG_FILE" || log_error "Failed to install NodeSource GPG key"
fi

if [[ ! -f "$nodesource_list" ]] || ! grep -Fq "deb.nodesource.com/node_${NODE_MAJOR}.x" "$nodesource_list" 2>/dev/null; then
    echo "deb [signed-by=${nodesource_key}] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" 2>>"$ERROR_LOG_FILE" | \
        sudo tee "$nodesource_list" > /dev/null 2>>"$ERROR_LOG_FILE" || log_error "Failed to write NodeSource apt source list"
    update_apt_cache
fi

install_apt_packages "nodejs"

if [[ ! -d "$HOME/.nvm" ]]; then
    nvm_install_script="$TEMP_DIR/nvm_install.sh"
    download_file_safe "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh" "$nvm_install_script"
    bash "$nvm_install_script" 2>>"$ERROR_LOG_FILE" || true
fi

python_packages=(
    "python3"
    "python3-pip"
    "python3-venv"
    "python3-dev"
)
install_apt_packages "${python_packages[@]}"

sudo npm install -g @vue/cli --loglevel=error --no-update-notifier 2>>"$ERROR_LOG_FILE" || true

libsecret_packages=(
    "libsecret-1-0"
    "libsecret-1-dev"
)
install_apt_packages "${libsecret_packages[@]}"

credential_src="/usr/share/doc/git/contrib/credential/libsecret"
credential_bin="$credential_src/git-credential-libsecret"
if [[ -d "$credential_src" ]] && [[ ! -x "$credential_bin" ]]; then
    (cd "$credential_src" && sudo make) 2>>"$ERROR_LOG_FILE" || true
fi

docker_deps=(
    "apt-transport-https"
    "ca-certificates"
    "gnupg"
    "lsb-release"
)
install_apt_packages "${docker_deps[@]}"

if [[ ! -f "/usr/share/keyrings/docker-archive-keyring.gpg" ]]; then
    curl -fsSL https://download.docker.com/linux/debian/gpg 2>>"$ERROR_LOG_FILE" | \
        sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 2>>"$ERROR_LOG_FILE" || true
fi

if ! grep -q "download.docker.com" /etc/apt/sources.list.d/*.list 2>/dev/null; then
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" 2>>"$ERROR_LOG_FILE" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 2>>"$ERROR_LOG_FILE" || true
    update_apt_cache
fi

docker_packages=(
    "docker-ce"
    "docker-ce-cli"
    "containerd.io"
    "docker-compose-plugin"
)
install_apt_packages "${docker_packages[@]}"

neovim_packages=(
    "neovim"
    "python3-neovim"
    "python3-dev"
    "python3-pip"
)
install_apt_packages "${neovim_packages[@]}"

dev_tools=(
    "gh"
    "shellcheck"
    "git"
    "golang-go"
)
install_apt_packages "${dev_tools[@]}"

sudo npm install -g bash-language-server pyright typescript-language-server yaml-language-server \
    --loglevel=error --no-update-notifier 2>>"$ERROR_LOG_FILE" || true

if ! command -v lua-language-server >/dev/null 2>&1; then
    latest_url=$(curl -sL -o /dev/null -w '%{url_effective}' --connect-timeout 10 --max-time 30 \
        https://github.com/LuaLS/lua-language-server/releases/latest 2>>"$ERROR_LOG_FILE")
    lls_version=${latest_url##*/}
    if [[ -n "$lls_version" ]]; then
        lls_tar="$TEMP_DIR/lua-language-server-${lls_version}-linux-x64.tar.gz"
        if download_file_safe \
            "https://github.com/LuaLS/lua-language-server/releases/download/${lls_version}/lua-language-server-${lls_version}-linux-x64.tar.gz" \
            "$lls_tar"; then
            lls_install_dir="$HOME/.local/share/lua-language-server"
            ensure_directory "$lls_install_dir"
            tar -xzf "$lls_tar" -C "$lls_install_dir" 2>>"$ERROR_LOG_FILE" || true
            if [[ -f "$lls_install_dir/bin/lua-language-server" ]]; then
                ensure_directory "$HOME/.local/bin"
                cat > "$HOME/.local/bin/lua-language-server" <<EOF
#!/bin/bash
exec "$lls_install_dir/bin/lua-language-server" "\$@"
EOF
                chmod +x "$HOME/.local/bin/lua-language-server" 2>>"$ERROR_LOG_FILE" || true
            fi
        fi
    fi
fi

lsp_packages=(
    "build-essential"
    "composer"
    "default-jdk-headless"
    "gzip"
    "liblua5.4-dev"
    "luarocks"
    "lua5.4"
    "php-cli"
    "php-mbstring"
    "php-xml"
    "php-zip"
    "ruby-dev"
    "ruby-full"
    "tar"
)
install_apt_packages "${lsp_packages[@]}"

install_apt_packages "julia" 2>>"$ERROR_LOG_FILE" || true

if [[ ! -f "$HOME/.cargo/env" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 2>>"$ERROR_LOG_FILE" || true
fi

curl -fsSL https://cursor.com/install | bash 2>>"$ERROR_LOG_FILE" || true

if ! command -v ollama >/dev/null 2>&1; then
    curl -fsSL https://ollama.com/install.sh | sh 2>>"$ERROR_LOG_FILE" || true
fi

if command -v gem >/dev/null 2>&1; then
    gem install --user-install solargraph 2>>"$ERROR_LOG_FILE" || true
fi

if [[ ! -x /usr/local/bin/ufw-docker ]]; then
    sudo wget -q -O /usr/local/bin/ufw-docker \
        https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker 2>>"$ERROR_LOG_FILE" || true
    sudo chmod +x /usr/local/bin/ufw-docker 2>>"$ERROR_LOG_FILE" || true
fi

if flatpak remote-info flathub >/dev/null 2>&1; then
    flatpak install -y flathub com.getpostman.Postman 2>>"$ERROR_LOG_FILE" || true
fi

pip3 install --user semgrep 2>>"$ERROR_LOG_FILE" || true

sg_binary="$TEMP_DIR/sg"
download_file_safe "https://sourcegraph.com/.api/src-cli/src_linux_amd64" "$sg_binary"
if [[ -f "$sg_binary" ]]; then
    chmod +x "$sg_binary" 2>>"$ERROR_LOG_FILE" || true
    sudo mv "$sg_binary" /usr/local/bin/sg 2>>"$ERROR_LOG_FILE" || true
fi
