#!/bin/bash

echo `date` > WVIEW.txt

# add repository to source.list
echo "deb-src http://mirrordirector.raspbian.org/raspbian/ wheezy main contrib non-free rpi" >> /etc/apt/sources.list

# update package list
sudo apt-get update

# install dependencies
sudo apt-get install --yes build-essential zlib1g-dev libpng12-dev libreadline-dev gawk libsqlite3-dev sqlite3 libgd2-xpm libgd2-xpm-dev libssl-dev sendmail sendemail libcurl4-openssl-dev libusb-1.0-0 libusb-1.0-0-dev apache2 php5 php5-sqlite libapache2-mod-php5 ntp tnftp wget

# wget http://downloads.sourceforge.net/radlib/radlib-2.12.0.tar.gz
wget https://dl.dropbox.com/u/2427470/raspberry/wview/radlib-2.12.0.tar.gz
tar zxvf radlib-2.12.0.tar.gz
cd radlib-2.12.0
./configure --enable-sqlite --prefix=/ --bindir=/usr/bin --sysconfdir=/etc --localstatedir=/var/lib --libdir=/usr/lib
sudo make install
cd ..

# wget http://downloads.sourceforge.net/wview/wview-5.20.2.tar.gz
wget https://dl.dropbox.com/u/2427470/raspberry/wview/wview-5.20.2.tar.gz
tar zxvf wview-5.20.2.tar.gz
cd wview-5.20.2
./configure --prefix=/ --bindir=/usr/bin --sysconfdir=/etc --localstatedir=/var/lib --libdir=/usr/lib
sudo make install
cd ..

# change init.d script
sudo wget http://goo.gl/H13iS -O /etc/init.d/wview
sudo chmod +x /etc/init.d/wview

# auto start up
sudo update-rc.d wview defaults 99

# add wview to apache
sudo ln -s /var/lib/wview/img/ /var/www/weather
sudo ln -s /var/lib/wviewmgmt/ /var/www/wviewmgmt

# little help
echo ""
echo "Type:"
echo "wviewconfig      to config your weather station"
echo "wviewhtmlconfig  to config your weather station web page"
echo ""
echo "go to http:// raspberrypi IP/wviewmgmt and set File Generation"
echo "Target Path to /var/lib/wview/img/"
echo "Source Path to /etc/wview/html/"
echo ""
echo "and finaly sudo /etc/init.d/wview start or sudo reboot"

# display start and end time of installation
echo `date` >> WVIEW.txt
cat WVIEW.txt ; rm WVIEW.txt

# chahu weird stuff :-/
sudo  /etc/init.d/wview start
sudo chmod -R 777  /etc/wview/
sudo reboot
