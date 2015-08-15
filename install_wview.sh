#!/bin/bash
echo "deb-src http://mirrordirector.raspbian.org/raspbian/ wheezy main contrib non-free rpi" >> /etc/apt/sources.list
sudo apt-get update
wget http://goo.gl/yiaz0 -O wview-install-raspbian.sh
chmod +x wview-install-raspbian.sh ; ./wview-install-raspbian.sh
sudo  /etc/init.d/wview start
sudo chmod -R 777  /etc/wview/
sudo reboot