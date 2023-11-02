#!/bin/bash

echo '#!/bin/bash' > /tmp/keepalive
echo 'while :; do echo -n -e "///////\v"; sleep 5; done' >> /tmp/keepalive
chmod 0777 /tmp/keepalive
sudo cp /tmp/keepalive /usr/bin


echo ${master_private_dns} >> /tmp/install-master

#URL=https://ip-172-31-19-226.eu-west-3.compute.internal:8140/packages/current/install.bash
URL=https://${master_private_dns}:8140/packages/current/install.bash

PE_INSTALL_SCRIPT_LOG=/tmp/install-script.log

echo ${node_os} >> $PE_INSTALL_SCRIPT_LOG

echo "Testing $URL connection" >> $PE_INSTALL_SCRIPT_LOG

while :
do
  curl -s -I -k --no-progress-meter $URL
  if [ $? == 0 ]
  then
    echo " $URL connection  ok"  >> $PE_INSTALL_SCRIPT_LOG
    break
  fi
  echo -n 1  >> $PE_INSTALL_SCRIPT_LOG
  sleep 1m
done

echo "Testing $URL content" >> $PE_INSTALL_SCRIPT_LOG

while :
do
  if [ $(curl -s -I -k --no-progress-meter $URL | head --lines=1 | grep 200 | wc -l) == 1 ]
  then
    echo " $URL content  ok"  >> $PE_INSTALL_SCRIPT_LOG
    break
  fi
  echo -n 2  >> $PE_INSTALL_SCRIPT_LOG
  sleep 1m
done


echo "Installing ..." >> $PE_INSTALL_SCRIPT_LOG

curl -k --no-progress-meter $URL 2>/tmp/install-error.log | sudo bash  # > /tmp/install.log

echo "Installing ok" >> $PE_INSTALL_SCRIPT_LOG


echo "Testing locked" >> $PE_INSTALL_SCRIPT_LOG

while :
do
  sudo test -f /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock

  if [ $? != 0 ]
  then
    echo "No locked" >> $PE_INSTALL_SCRIPT_LOG
    break
  fi
  echo -n 3  >> $PE_INSTALL_SCRIPT_LOG
  sleep 1m
done

sudo puppet agent -t --waitforlock 60 --waitforcert 60 --logdest /tmp/puppet-agent-log

echo "puppet agent -t ok" >> $PE_INSTALL_SCRIPT_LOG

runinterval=60s
puppet config --section agent set runinterval $runinterval

echo "set runinterval=$runinterval" >> $PE_INSTALL_SCRIPT_LOG

echo "installation complete" >> $PE_INSTALL_SCRIPT_LOG

########
