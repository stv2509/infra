#!/bin/bash

sudo su - appuser
cd /home/appuser/
echo "user:"  $(whoami)  >> /home/appuser/install.log
echo "pwd:"  $(pwd) >> /home/appuser/install.log

echo "###############- Start install app -###############" >> /home/appuser/install.log

git clone https://github.com/stv2509/infra.git
cd infra && bundle update sinatra && bundle install
puma -d

if ps aux | grep puma | grep -v grep
then
	echo "SUCCESS: Reddit application up and running" >> /home/appuser/install.log
else
	echo "ERROR: Reddit application failed to start" >> /home/appuser/install.log
fi
