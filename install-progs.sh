#!/bin/bash
echo -e "----------------------------------------- Script directory ---------------------------------------------------------\n" $0

echo '#!/bin/bash' > /tmp/keepalive
echo "trap 'echo; exit 0;' INT" >> /tmp/keepalive
echo 'while :; do  sleep 1; printf "\x0d"; now=`date +"%T"`; echo -n $now; done' >> /tmp/keepalive
#echo 'while :; do for x in {1..50}; do printf "\033[1C"; sleep 2; done; for x in {1..50}; do printf "\033[1D"; sleep 2; done done' >> /tmp/keepalive

chmod 0777 /tmp/keepalive
sudo cp /tmp/keepalive /usr/bin


echo "------------------------------------------- Install net-tools ----------------------------------------------------------"
apt-get -yqq update
apt-get -yqq install net-tools

echo "------------------------------------------- prepare git installation ---------------------------------------------------"
add-apt-repository --yes ppa:git-core/ppa

echo "------------------------------------------- prepare nodejs installation ------------------------------------------------"
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

echo "------------------------------------------- Install git ----------------------------------------------------------------"
apt-get -yqq update
apt-get -yqq install git
git config --system credential.helper store
echo "------------------------------------------- Install nodejs -------------------------------------------------------------"
apt-get -yqq install nodejs

echo "------------------------------------------- Install docker -------------------------------------------------------------"
sudo apt-get -yqq update
sudo apt-get -yqq install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -yqq update

sudo apt-get -yqq install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "------------------------------------------- Install tree ---------------------------------------------------------------"
sudo apt-get -yqq install tree

echo "------------------------------------------- Install xrdp ---------------------------------------------------------------"
sudo apt-get -yqq install xrdp
sudo systemctl enable xrdp
echo "------------------------------------------- Install xfce ---------------------------------------------------------------"
sudo apt-get -yqq install xfce4
sudo apt-get -yqq install xfce4-terminal tango-icon-theme
sudo echo xfce4-session > ~/.xsession
sudo service xrdp restart
echo "------------------------------------------- Install google chrome ------------------------------------------------------"
sudo wget -nv https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo chmod 0666 google-chrome-stable_current_amd64.deb
sudo apt-get -yqq  install ./google-chrome-stable_current_amd64.deb || true
#echo "------------------------------------------- Install gnome --------------------------------------------------------------"
#sudo add-apt-repository --yes ppa:gnome3-team/gnome3
#sudo apt-get -yqq install gnome-shell ubuntu-gnome-desktop

echo "------------------------------------------- Set passwd for ubuntu ------------------------------------------------------"
echo ubuntu:ubup@ss0 | sudo chpasswd

echo "------------------------------------------- Install golang -------------------------------------------------------------"
cd /tmp
sudo wget -nv https://go.dev/dl/go1.21.5.linux-amd64.tar.gz

sudo rm -rf /usr/bin/go
tar -C /usr/local -xzf /tmp/go1.21.5.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin
echo PATH=$PATH >> ~/.bashrc
source ~/.bashrc

echo "-------------------------------------------- Install kind --------------------------------------------------------------"
sudo GOPATH=/usr/local/go /usr/local/go/bin/go install sigs.k8s.io/kind@v0.20.0
echo "Install kind: "$?

echo "-------------------------------------------- Install kubectl -----------------------------------------------------------"
sudo apt-get -yqq update
sudo apt-get -yqq install apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get -yqq update
sudo apt-get -yqq install kubectl

echo "-------------------------------------------- Install terraform ---------------------------------------------------------"
wget -O - https://apt.releases.hashicorp.com/gpg 2>/dev/null | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get -yqq update || true
sudo apt-get -yqq install terraform

echo "-------------------------------------------- Install azure-cli ---------------------------------------------------------"
sudo apt-get -yqq update
sudo apt-get -yqq install ca-certificates curl apt-transport-https lsb-release gnupg
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor |    sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
AZ_DIST=$(lsb_release -cs)
echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
echo AZ_DIST-$AZ_DIST

sudo apt-get -yqq update
sudo apt-get -yqq install azure-cli

echo "-------------------------------------------- Install vscode ------------------------------------------------------------"
sudo apt-get -yqq update
sudo apt-get -yqq install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt-get -yqq update
sudo apt-get -yqq install code

echo "-------------------------------------------- Install k9s ---------------------------------------------------------------"
cd /tmp
wget -nv https://github.com/derailed/k9s/releases/download/v0.31.5/k9s_Linux_amd64.tar.gz
sudo tar -C /usr/bin -xzf k9s_Linux_amd64.tar.gz

echo "-------------------------------------------- Cluster template ----------------------------------------------------------"
echo "kind: Cluster" >> /tmp/cluster-template.yaml
echo "apiVersion: kind.x-k8s.io/v1alpha4" >> /tmp/cluster-template.yaml
echo "nodes:" >> /tmp/cluster-template.yaml
echo "- role: control-plane" >> /tmp/cluster-template.yaml
echo "- role: worker" >> /tmp/cluster-template.yaml
echo "- role: worker" >> /tmp/cluster-template.yaml
echo "- role: worker" >> /tmp/cluster-template.yaml

