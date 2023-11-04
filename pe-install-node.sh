#!/bin/bash

PROGRESS=/tmp/pa-installation.progress
pwd >> $PROGRESS

echo '#!/bin/bash' > /tmp/keepalive
echo 'while :; do echo -n -e "///////\v"; sleep 5; done' >> /tmp/keepalive
chmod 0777 /tmp/keepalive
sudo cp /tmp/keepalive /usr/bin


echo ${master_private_dns} >> /tmp/install-master

URL=https://${master_private_dns}:8140/packages/current/install.bash

echo ${node_os} >> $PROGRESS

echo "Testing $URL connection" >> $PROGRESS
while :
do
  curl -s -I -k --no-progress-meter $URL
  if [ $? == 0 ]
  then
    echo "$URL connection  ok"  >> $PROGRESS
    break
  fi
  echo -n ". "  >> $PROGRESS
  sleep 1m
done

echo "Testing $URL content" >> $PROGRESS
while :
do
  if [ $(curl -s -I -k --no-progress-meter $URL | head --lines=1 | grep 200 | wc -l) == 1 ]
  then
    echo "$URL content  ok"  >> $PROGRESS
    break
  fi
  echo -n ". "  >> $PROGRESS
  sleep 1m
done


echo "Installing ..." >> $PROGRESS
curl -k --no-progress-meter $URL 2>/tmp/install-error.log | sudo bash
ok=$?
if [ $ok != 0 ]
then
  echo "installation error ok($ok)" >> $PROGRESS
  exit $ok
fi
echo "Installing ok($ok)" >> $PROGRESS

echo "Testing locked" >> $PROGRESS
while :
do
  sudo test -f /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock

  if [ $? != 0 ]
  then
    echo "No locked" >> $PROGRESS
    break
  fi
  echo -n ". "  >> $PROGRESS
  sleep 1m
done

sudo puppet agent -t --waitforlock 60 --waitforcert 60 --logdest /tmp/puppet-agent-log
echo "puppet agent -t ok($?)" >> $PROGRESS

runinterval=60s
puppet config --section agent set runinterval $runinterval
echo "set runinterval=$runinterval" >> $PROGRESS

echo "installation complete" >> $PROGRESS

########
