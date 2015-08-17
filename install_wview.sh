#!/bin/bash

# pacakge version
radlib="radlib-2.12.0"
wview="wview-5.21.7"

date > WVIEW.txt

# add repository to source.list
echo "deb-src http://mirrordirector.raspbian.org/raspbian/ wheezy main contrib non-free rpi" >> /etc/apt/sources.list

# update package list
sudo apt-get update

# install dependencies
sudo apt-get install --yes build-essential zlib1g-dev libpng12-dev libreadline-dev gawk libsqlite3-dev sqlite3 libgd2-xpm libgd2-xpm-dev libssl-dev sendmail sendemail libcurl4-openssl-dev libusb-1.0-0 libusb-1.0-0-dev apache2 php5 php5-sqlite libapache2-mod-php5 ntp tnftp wget

# download and install radlib
wget http://downloads.sourceforge.net/radlib/$radlib.tar.gz
tar zxvf $radlib.tar.gz
cd $radlib
./configure --enable-sqlite --prefix=/ --bindir=/usr/bin --sysconfdir=/etc --localstatedir=/var/lib --libdir=/usr/lib
sudo make install
cd ..

# download and install wview
wget http://downloads.sourceforge.net/wview/$wview.tar.gz
tar zxvf $wview.tar.gz
cd $wview
./configure --prefix=/ --bindir=/usr/bin --sysconfdir=/etc --localstatedir=/var/lib --libdir=/usr/lib
sudo make install
cd ..

# change init.d script
sudo mv init.d_wview /etc/init.d/wview

# auto start up
sudo update-rc.d wview defaults 99

# add wview to apache
sudo ln -s /var/lib/wview/img/ /var/www/weather
sudo ln -s /var/lib/wviewmgmt/ /var/www/wviewmgmt

ip=$(ifconfig | grep "inet addr" | grep -v "127.0.0.1" | cut -d ':' -f 2 | cut -d ' ' -f 1)
# little help
echo ""
echo "Type:"
echo "wviewconfig      to config your weather station"
echo "wviewhtmlconfig  to config your weather station web page"
echo ""
echo "go to http://$ip/wviewmgmt and set File Generation"
echo "Target Path to /var/lib/wview/img/"
echo "Source Path to /etc/wview/html/"
echo ""
echo "and finaly sudo /etc/init.d/wview start or sudo reboot"

# display start and end time of installation
date >> WVIEW.txt
cat WVIEW.txt
rm WVIEW.txt

# chahu weird stuff :-/
sudo  /etc/init.d/wview start
sudo chmod -R 777  /etc/wview/
sudo reboot
