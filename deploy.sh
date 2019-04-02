#!/bin/bash

echo "Start install app"

git clone -b monolith https://github.com/express42/reddit.git
source /home/appuser/.rvm/scripts/rvm
cd reddit && bundle update sinatra && bundle install
puma -d

if ps aux | grep puma | grep -v grep
then
        echo "SUCCESS: Reddit application up and running"
else
        echo "ERROR: Reddit application failed to start"
fi