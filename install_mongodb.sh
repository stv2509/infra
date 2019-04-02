#!/bin/bash

echo "Start Install MongoDB"

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.0.list'
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

if sudo systemctl status mongod | grep "active (running)"
then
        echo "SUCCESS: MongoDB installed and running"
else
        echo "ERROR: MongoDB not active"
fi

echo "Finish Install MongoDB"