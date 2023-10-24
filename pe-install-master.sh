#!/bin/bash

echo '#!/bin/bash' > /tmp/keepalive
echo 'while :; do echo -n -e "///////\v"; sleep 5; done' >> /tmp/keepalive
chmod 0777 /tmp/keepalive
cp /tmp/keepalive /usr/bin

PROGRESS=/tmp/pe-installation.progress

cd /tmp
mkdir puppet
cd puppet

echo curl >> $PROGRESS

curl -JLO "https://pm.puppet.com/cgi-bin/download.cgi?dist=ubuntu&rel=20.04&arch=amd64&ver=latest"

echo tar >> $PROGRESS

tar -xf *.tar.gz
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


runinterval=25s
puppet config --section agent set runinterval $runinterval

echo "set runinterval=$runinterval" >> $PROGRESS


echo "installing tree" >> $PROGRESS
puppet apply -e 'package { 'tree': ensure => present, provider => apt }'

echo "installing pdk" >> $PROGRESS
cd /tmp
wget https://apt.puppet.com/puppet-tools-release-focal.deb
sudo dpkg -i puppet-tools-release-focal.deb
sudo apt-get update
sudo apt-get install pdk

echo "installation complete" >> $PROGRESS

