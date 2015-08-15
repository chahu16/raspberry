#!/bin/bash

# repository from official manuel
DEP="http://www.wviewweather.com/apt/wheezy wheezy main"
# repository from rpi specific tutorial
#DEP="http://mirrordirector.raspbian.org/raspbian/wheezy main contrib non-free rpi"

# sources.list
SRCL="/etc/apt/sources.list"

# check if repository isn't add
if [[ -z "`grep $DEP $SRCL`" ]]; then
    # add repository
    echo "Adding repository to $SRCL"
    echo "deb $DEP" > $SRCL
    echo "deb-src $DEP" > $SRCL

    # upade package list
    echo "Update package list"
    sudo apt-get update
fi

if [[ -z "`apt-cache search wview 2> /dev/null | grep wview`" ]]; then
    echo "Can't locate wview package, installation abort" >&2
    exit 1
fi

# install wview
echo "Install wview"
sudo apt-get install wview

# check if installation succesfull
if [[ "$?" != 0 ]]; then
    echo "Installation failed. Check apt log"
    exit 1
fi

# wait for user input
echo "Installation is complete, check if wview simulation is running."
read -p "Is the simulation running ? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation abort"
    exit 1
fi

# stop process and clear fake data
sudo /etc/init.d/wview stop
sudo wviewcleardata
