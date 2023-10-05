#!/bin/bash


############################################### Things to do after installing fedora ##########################

# Edit the dnf.conf file with nano and add the specified lines
sudo nano /etc/dnf/dnf.conf <<EOL
max_parallel_downloads=10
fastestmirror=True
EOL

# Save and exit nano

# Update and upgrade the system using dnf
sudo dnf update -y && sudo dnf upgrade -y

# Refresh fwupd metadata
sudo fwupdmgr refresh --force


################################### Git install #####################################################

# Check if Git is already installed
if ! command -v git &>/dev/null; then
    # Update the package manager's cache
    sudo dnf update -y

    # Install Git
    sudo dnf install git -y

    # Verify the installation
    if command -v git &>/dev/null; then
        echo "Git has been successfully installed."
    else
        echo "Failed to install Git."
    fi
else
    echo "Git is already installed."
fi

############################################## All Flatpak Application installation ################################

# Check if Flatpak is installed
if ! command -v flatpak &> /dev/null; then
  echo "Flatpak is not installed. Installing Flatpak..."
  # Install Flatpak (you might need to adapt this to your Linux distribution)
  sudo apt-get install flatpak  # Example for Ubuntu-based systems
  # Add the Flathub remote
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# List of Flatpak applications to install
echo "Installing all necessary Flatpak applications"
flatpak_apps=(
  "md.obsidian.Obsidian"
  "com.brave.Browser"
  "com.google.Chrome"
  "com.mattjakeman.ExtensionManager"
  "org.telegram.desktop"
  "com.discordapp.Discord"
  "com.todoist.Todoist"
  "com.spotify.Client"
  "com.github.PintaProject.Pinta"
  "org.videolan.VLC"
  "com.github.tchx84.Flatseal"
  "us.zoom.Zoom"
  "com.getpostman.Postman"
  "org.onlyoffice.desktopeditors"
  "com.github.tchx84.Flatseal"
)

# Iterate through the list and install each application
for app in "${flatpak_apps[@]}"; do
  flatpak install flathub "$app" -y
done


echo "Flatpak applications have been installed."


###############################################   Mongo DB #################################################################

# Check if MongoDB is already installed
echo "Now Setting Up mongodb"
if command -v mongod &>/dev/null; then
    echo "MongoDB is already installed."
else
    # Create the MongoDB repository configuration file
    sudo tee /etc/yum.repos.d/mongodb-org-4.4.repo <<EOL
[Mongodb]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOL

    # Install MongoDB
    sudo dnf install mongodb-org -y

    # Start and enable MongoDB service
    sudo systemctl enable mongod.service
    sudo systemctl start mongod.service

    echo "MongoDB has been installed and started."
fi


############################################################# Docker Setup #####################################################
# Configuring docker

echo "Now Setting up docker"
# Check if Docker is already installed
if command -v docker &>/dev/null; then
    echo "Docker is already installed."
else
    # Install required packages
    sudo dnf -y install dnf-plugins-core

    # Add Docker repository
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

    # Install Docker
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # Start Docker service
    sudo systemctl start docker

    # Test Docker installation
    sudo docker run hello-world

    # Add the current user to the docker group
    sudo usermod -aG docker ${USER}

    username=$(whoami)

    su - ${USER}

    groups

    sudo usermod -aG docker "$username"

    echo "Docker has been installed and configured."
fi


############################################# Latest Vs code installation ####################################################

# Define the URL to download the .rpm package
download_url="https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"

# Define the directory where you want to save the downloaded .rpm file
download_dir="$HOME/Downloads"

# Define the path to the downloaded .rpm package
rpm_file="$download_dir/code.rpm"

# Create the download directory if it doesn't exist
mkdir -p "$download_dir"

# Check if the .rpm file exists
if [ -f "$rpm_file" ]; then
    echo "Visual Studio Code .rpm package found at: $rpm_file"
else
    # Download the .rpm package
    wget -O "$rpm_file" "$download_url"
    
    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Visual Studio Code .rpm package has been downloaded to $download_dir."
    else
        echo "Failed to download Visual Studio Code. Please check your internet connection."
        exit 1
    fi
fi

# Install the downloaded .rpm package
sudo dnf install "$rpm_file"

echo "Visual Studio Code has been installed."


#########################################################  Installing and setting up the zsh terminal #####################################3

echo "Setting Zsh in you terminal"
# Install Zsh
if ! command -v zsh &> /dev/null; then
    echo "Zsh is not installed. Installing Zsh..."
    sudo dnf install -y zsh
fi

# Check if Oh My Zsh is already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is not installed. Installing Oh My Zsh..."
    
    # Clone the Oh My Zsh repository to the home directory
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    
    # Run the Oh My Zsh installation script
    chmod +x "$HOME/.oh-my-zsh/tools/install.sh"
    "$HOME/.oh-my-zsh/tools/install.sh"
    
    echo "Oh My Zsh installed successfully."
fi


########################################################    installing node and nvm ####################################################################

echo "Installing NVM and Node"
# Check if NVM is already installed
if [ ! -d "$HOME/.nvm" ]; then
    echo "NVM is not installed. Installing..."

    # Clone the NVM repository to the home directory
    git clone https://github.com/nvm-sh/nvm.git "$HOME/.nvm"

    # Source NVM script to make it available in this script
    source "$HOME/.nvm/nvm.sh"

    # Install the latest version of Node.js
    nvm install node

    # Set the newly installed Node.js version as the default
    nvm use node

    echo "NVM and Node.js installed successfully."
else
    echo "NVM is already installed."
fi

# Display Node.js and NVM versions
node -v
nvm --version


############################################ installing typescript and yarn ##########################################################

echo "Installing TypeScript and Yarn"

# Install TypeScript globally
npm install -g typescript

# Install Yarn globally
npm install -g yarn

# Display TypeScript and Yarn versions
echo "TypeScript version:"
tsc -v

echo "Yarn version:"
yarn -v


################################################################## installing preloader #########################################

# Check if preload is already installed
if ! command -v preload &> /dev/null; then
    echo "Preload is not installed. Installing preload..."
    
    # Install preload using dnf
    sudo dnf install -y preload
    
    echo "Preload installed successfully."
else
    echo "Preload is already installed."
fi

# Start the preload service and enable it at boot
sudo systemctl start preload
sudo systemctl enable preload

echo "Preload is set up and running."








