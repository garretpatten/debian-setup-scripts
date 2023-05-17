# Install Terminator and zsh
terminalApps=("terminator" "zsh")
for terminalApp in ${terminalApps[@]}; do
    if [[ -f "/usr/bin/$terminalApp" ]]; then
        echo "$terminalApp is already installed."
    else
        echo y | yay -S "$terminalApp"
    fi
done

# Change User Shells to Zsh
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# Install oh-my-zsh and configure shell
if [[ -d "~/.oh-my-zsh/" ]]; then
    echo "oh-my-zsh is already installed."
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    cd ~/.oh-my-zsh/custom/plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions.git
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
install
    cat "$(pwd)/src/artifacts/zsh/zshrc.txt" > ~/.zshrc
fi

# Reload config file
source ~/.zshrc
