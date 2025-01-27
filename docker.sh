cript to install Docker on Ubuntu
echo "Updating package index..."
sudo apt-get update -y

echo "Installing prerequisites..."
sudo apt-get install -y \
	    apt-transport-https \
	        ca-certificates \
		    curl \
		        software-properties-common

echo "Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "Adding Docker's APT repository..."
echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index to include Docker's repository..."
sudo apt-get update -y

echo "Installing Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Verifying Docker installation..."
if docker --version; then
	    echo "Docker installed successfully!"
    else
	        echo "Docker installation failed."
		    exit 1
fi

echo "Configuring Docker user permissions..."
sudo groupadd docker
sudo usermod -aG docker $(whoami)
echo "You need to log out and back in or run 'newgrp docker' to apply these changes."

echo "Docker setup complete!"

