#!/bin/bash

sudo su - appuser
cd /home/appuser/
echo "user:"  $(whoami)  >> /home/appuser/install.log
echo "pwd:"  $(pwd) >> /home/appuser/install.log
echo "###############Start Install Ruby###############" >> /home/appuser/install.log

gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
unset rvm_path
curl -sSL https://get.rvm.io | bash -s stable
source /home/appuser/.rvm/scripts/rvm
rvm requirements
rvm install 2.4
rvm use 2.4.5 --default
gem install bundler -V --no-ri --no-rdoc
source /home/appuser/.rvm/scripts/rvm


if /home/appuser/.rvm/rubies/ruby-2.4.5/bin/ruby -v | grep "ruby 2.4"
then
	echo "SUCCESS: Ruby Installed" >> /home/appuser/install.log
else
	echo "ERROR: Ruby was not installed or version is wrong" >> /home/appuser/install.log
fi

if /home/appuser/.rvm/rubies/ruby-2.4.5/bin/bundle -v | grep "Bundler version 2.0"
then
	echo "SUCCESS: Bundler Installed" >> /home/appuser/install.log
else
	echo "ERROR: Bundler was not installed or version is wrong" >> /home/appuser/install.log
fi

echo "###############- Finish Install Ruby -###############" >> /home/appuser/install.log


echo "###############- Start Install MongoDB -###############" >> /home/appuser/install.log

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.0.list'
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

if sudo systemctl status mongod | grep "active (running)"
then
	echo "SUCCESS: MongoDB installed and running" >> /home/appuser/install.log
else
	echo "ERROR: MongoDB not active" >> /home/appuser/install.log
fi

echo "###############- Finish Install MongoDB -###############" >> /home/appuser/install.log


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
