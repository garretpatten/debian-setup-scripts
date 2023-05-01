# Install Terminator
sudo dnf install terminator -y

# Install Zsh
sudo dnf install zsh -y

# Change User Shells to Zsh
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install plugins
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

# Update config file
cat "$(pwd)/src/artifacts/zsh/zshrc.txt" > ~/.zshrc

# Reload config file
source ~/.zshrc
