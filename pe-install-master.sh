#!/bin/bash

echo '#!/bin/bash' > /tmp/keepalive
echo "trap 'echo; exit 0;' INT" >> /tmp/keepalive
echo 'while :; do for x in {1..50}; do printf "\033[1C"; sleep 2; done; for x in {1..50}; do printf "\033[1D"; sleep 2; done done' >> /tmp/keepalive

chmod 0777 /tmp/keepalive
sudo cp /tmp/keepalive /usr/bin

PROGRESS=/tmp/pe-installation.progress

cd /tmp
mkdir puppet
cd puppet

echo curl >> $PROGRESS
curl -JLO "https://pm.puppet.com/cgi-bin/download.cgi?dist=ubuntu&rel=20.04&arch=amd64&ver=latest"
echo "curl ok($?)" >> $PROGRESS

echo tar >> $PROGRESS
tar -xf *.tar.gz
echo "tar ok($?)" >> $PROGRESS
rm *.tar.gz

cd pupp*

echo "Installer starting ..." >> $PROGRESS
./puppet-enterprise-installer -y -c conf.d/pe.conf
echo "Install ok($?)" >> $PROGRESS

puppet infrastructure console_password --password adminp@ss
echo "admin pass ok($?)" >> $PROGRESS

sudo echo "#!/bin/bash" > /etc/puppetlabs/puppet/autosign.conf
sudo echo "echo -n \`date\`: >> /tmp/autosign.log" >> /etc/puppetlabs/puppet/autosign.conf
sudo echo "echo \$1 >> /tmp/autosign.log" >> /etc/puppetlabs/puppet/autosign.conf
sudo echo "cat -    >> /tmp/autosign.log" >> /etc/puppetlabs/puppet/autosign.conf
sudo echo "exit 0" >> /etc/puppetlabs/puppet/autosign.conf
sudo chmod 0777 /etc/puppetlabs/puppet/autosign.conf

echo Autosign >> $PROGRESS
puppet config --section master set autosign /etc/puppetlabs/puppet/autosign.conf

echo Puppet-conf >> $PROGRESS

puppet agent -t --logdest /tmp/agent-log1
echo "agent phase 1 ok($?)" >> $PROGRESS

puppet agent -t --logdest /tmp/agent-log2
echo "agent phase 2 ok($?)" >> $PROGRESS

runinterval=60s
puppet config --section agent set runinterval $runinterval
echo "set runinterval=$runinterval" >> $PROGRESS


echo "installing tree" >> $PROGRESS
puppet apply -e 'package { 'tree': ensure => present, provider => apt }'

cd /tmp

echo "preparing pdk, bolt" >> $PROGRESS
wget https://apt.puppet.com/puppet-tools-release-focal.deb
sudo dpkg -i puppet-tools-release-focal.deb

echo "preparing  .NET" >> $PROGRESS
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get update

echo "installing pdk" >> $PROGRESS
sudo apt-get install -y pdk

echo "installing bolt" >> $PROGRESS
sudo apt-get install -y puppet-bolt

echo "installing hiera" >> $PROGRESS
sudo apt-get install -y hiera

echo "installing .NET" >> $PROGRESS
sudo apt-get install -y dotnet-sdk-7.0

echo "installing GCM" >> $PROGRESS
sudo dotnet tool install -g git-credential-manager
sudo echo "PATH=\$PATH:/root/.dotnet/tools" >> /etc/bash.bashrc

echo "installing gitsome" >> $PROGRESS
sudo apt-get install -y gitsome

sudo echo "git config credential.helper store" > /usr/bin/gitcred
chmod 0777 /usr/bin/gitcred

cd /etc/puppetlabs/code/environments
sudo rm -r /etc/puppetlabs/code/environments/*
echo "rm environments/* ok=($?)" >> $PROGRESS

git clone https://github.com/gitsokos/PE-master-env .
echo "clone git ok=($?)" >> $PROGRESS

sudo chown -R pe-puppet:pe-puppet *

git config credential.helper store

echo "installation complete" >> $PROGRESS


# /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/puppetlabs/bin
# /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/root/.dotnet/tools

##
