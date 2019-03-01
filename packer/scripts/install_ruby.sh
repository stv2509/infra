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

