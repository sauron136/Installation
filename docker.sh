#!/bin/bash

# Exit immediately if any command fails
set -e

# Check for sudo privileges
if [ "$EUID" -ne 0 ]; then
	    echo "Please run this script as root or with sudo."
	        exit 1
fi

# Check if Docker is already installed
if command -v docker &> /dev/null; then
	    echo "Docker is already installed."
	        docker --version
		    exit 0
fi

# Check if the system is Ubuntu
if ! lsb_release -cs &> /dev/null; then
	    echo "This script is intended for Ubuntu only."
	        exit 1
fi

# Update package index
echo "Updating package index..."
sudo apt-get update -y

# Install prerequisites
echo "Installing prerequisites..."
sudo apt-get install -y \
	    apt-transport-https \
	        ca-certificates \
		    curl \
		        software-properties-common

# Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker's APT repository
echo "Adding Docker's APT repository..."
echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index to include Docker's repository
echo "Updating package index to include Docker's repository..."
sudo apt-get update -y

# Install Docker Engine
echo "Installing Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Verify Docker installation
echo "Verifying Docker installation..."
if docker --version; then
	    echo "Docker installed successfully!"
    else
	        echo "Docker installation failed."
		    exit 1
fi

# Configure Docker user permissions
echo "Configuring Docker user permissions..."
if getent group docker &> /dev/null; then
	    echo "The 'docker' group already exists."
    else
	        echo "Creating the 'docker' group..."
		    sudo groupadd docker
fi

if id -nG "$(whoami)" | grep -qw "docker"; then
	    echo "The user $(whoami) is already in the 'docker' group."
    else
	        echo "Adding the user $(whoami) to the 'docker' group..."
		    sudo usermod -aG docker $(whoami)
		        echo "You need to log out and back in or run 'newgrp docker' to apply these changes."
fi

echo "Docker setup complete!"
