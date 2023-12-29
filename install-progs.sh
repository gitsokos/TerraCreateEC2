#!/bin/bash
echo -n "working directory: " $0

echo '#!/bin/bash' > /tmp/keepalive
echo "trap 'echo; exit 0;' INT" >> /tmp/keepalive
echo 'while :; do for x in {1..50}; do printf "\033[1C"; sleep 2; done; for x in {1..50}; do printf "\033[1D"; sleep 2; done done' >> /tmp/keepalive

chmod 0777 /tmp/keepalive
sudo cp /tmp/keepalive /usr/bin


echo "------------------------------------------- prepare git installation ---------------------------------------------------"
add-apt-repository --yes ppa:git-core/ppa

echo "------------------------------------------- prepare nodejs installation ------------------------------------------------"
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

echo "------------------------------------------- Install git and nodejs -----------------------------------------------------"
apt-get update
apt-get -yqq install git
apt-get -yqq install nodejs

echo "------------------------------------------- Add Docker's official GPG key ----------------------------------------------"
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "------------------------------------------- Add the repository to Apt sources ------------------------------------------"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "------------------------------------------- Install docker -------------------------------------------------------------"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt-get install -y tree

echo "------------------------------------------- Install xrdp ---------------------------------------------------------------"
sudo apt install -y xrdp
sudo systemctl enable xrdp
echo "------------------------------------------- Install gnome --------------------------------------------------------------"
sudo add-apt-repository -y ppa:gnome3-team/gnome3
sudo apt-get install -y gnome-shell ubuntu-gnome-desktop

echo "------------------------------------------- Set passwd for ubuntu ------------------------------------------------------"
echo ubuntu:ubuntu000 | sudo chpasswd

echo "------------------------------------------- Install golang -------------------------------------------------------------"
cd /tmp
sudo wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz

sudo rm -rf /usr/bin/go
tar -C /usr/local -xzf /tmp/go1.21.5.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin
echo PATH=$PATH >> ~/.bashrc
source ~/.bashrc

echo "-------------------------------------------- Install kind --------------------------------------------------------------"
sudo GOPATH=/usr/local/go /usr/local/go/bin/go install sigs.k8s.io/kind@v0.20.0
echo "Install kind: "$?

echo "-------------------------------------------- Install kubectl -----------------------------------------------------------"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

echo "-------------------------------------------- Install terraform ---------------------------------------------------------"
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update || true
sudo apt install terraform
