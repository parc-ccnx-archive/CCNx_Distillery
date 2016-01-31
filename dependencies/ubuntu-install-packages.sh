#!/bin/bash

required_packages=`cat ubuntu-packages.list`
echo sudo apt-get install $required_packages
sudo apt-get install $required_packages
