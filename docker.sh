t on any error
set -e

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Updating package information...${NC}"
sudo apt-get update -y

echo -e "${GREEN}Installing prerequisite packages...${NC}"
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

echo -e "${GREEN}Adding Docker's official GPG key...${NC}"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo -e "${GREEN}Adding Docker repository to APT sources...${NC}"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e "${GREEN}Updating package information again...${NC}"
sudo apt-get update -y

echo -e "${GREEN}Installing Docker Engine, CLI, and Containerd...${NC}"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo -e "${GREEN}Ensuring Docker service is running...${NC}"
sudo systemctl start docker
sudo systemctl enable docker

echo -e "${GREEN}Docker has been installed successfully.${NC}"

