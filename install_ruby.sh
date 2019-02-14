#!/bin/bash

echo "Start Install Ruby"

gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /home/appuser/.rvm/scripts/rvm
rvm requirements
rvm install 2.4
rvm use 2.4.5 --default
gem install bundler -V --no-ri --no-rdoc

if ruby -v | grep "ruby 2.4"
then
	echo "SUCCESS: Ruby Installed"
else
	echo "ERROR: Ruby was not installed or version is wrong"
fi

if bundler -v | grep "Bundler version 1.11"
then
	echo "SUCCESS: Bundler Installed"
else
	echo "ERROR: Bundler was not installed or version is wrong"
fi

echo "Finish Install Ruby"
