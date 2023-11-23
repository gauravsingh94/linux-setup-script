#!/bin/bash

echo "Downloading Vs code...."
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
