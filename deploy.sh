#!/bin/bash

echo "Start install app"

git clone https://github.com/stv2509/infra.git
cd infra && bundle update sinatra && bundle install
puma -d

if ps aux | grep puma | grep -v grep
then
	echo "SUCCESS: Reddit application up and running"
else
	echo "ERROR: Reddit application failed to start"
fi
