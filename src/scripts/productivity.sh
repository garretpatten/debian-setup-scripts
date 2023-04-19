# Install taskwarrior
sudo dnf install task -y

# Update config file
cat ../artifacts/taskwarrior/taskrcUpdates.txt >> ~/.taskrc

# TODO: Run python script to set dark blue theme

# Add directory for custom themes
mkdir ~/.task/themes/

### TODO: Update this from copying an artifact to pulling themes from GitHub ###
# Add custom themes to directory
cp ../artifacts/taskwarrior/themes/ ~/.task/themes/

# Install Todoist
flatpak install flathub com.todoist.Todoist
