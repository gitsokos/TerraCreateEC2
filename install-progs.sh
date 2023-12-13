#!/bin/bash

echo '#!/bin/bash' > /tmp/keepalive
echo "trap 'echo; exit 0;' INT" >> /tmp/keepalive
echo 'while :; do for x in {1..50}; do printf "\033[1C"; sleep 2; done; for x in {1..50}; do printf "\033[1D"; sleep 2; done done' >> /tmp/keepalive

chmod 0777 /tmp/keepalive
sudo cp /tmp/keepalive /usr/bin


# prepare git installation
add-apt-repository --yes ppa:git-core/ppa

# prepare nodejs installation
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# install
apt-get update
apt-get -yqq install git
apt-get -yqq install nodejs

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
