#!/bin/bash

required_packages=`cat ubuntu-packages.list`


package_check_fail(){
  echo ""
  echo " ================================================= "
  echo "ERROR: The package check has failed."
  echo ""
  echo "You do not have the required packages installed on your system, please install them."
  echo ""
  echo "You can run the command:"
  echo "  sudo apt-get install $required_packages"
  echo ""
  echo "alternatively you can just run it via the Makefile"
  echo "  make -C dependencies fix-as-root"
  echo ""
  echo "You can also disable this check by setting DISABLE_UBUNTU_PACKAGE_CHECK=True"
  echo "This is done in the config.local.mk file"
  echo "Please see the config.local.mk file for more information"
  exit 1
}

package_check_installed(){
  package=$1
  INSTALLED=`dpkg-query -W -f='${Status}\n' $package | awk '{print $3}'`
  if [ "status-${INSTALLED}" != "status-installed" ]; then
    echo "Package $package is not installed"
    package_check_fail
  fi
}

for package in $required_packages; do
	package_check_installed $package
done
