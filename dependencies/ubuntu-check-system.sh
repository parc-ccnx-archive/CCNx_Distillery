#!/bin/sh

system_check_error(){
  echo ""
  echo "ERROR: You are not running Ubuntu 14.04"
  echo ""
  echo "If you want to IGNORE this error please set DISABLE_UBUNTU_CHECK=True"
  echo "This is done in the config.local.mk file"
  echo "Please see the config.local.mk file for more information"
  exit 1
}

system_check_ubuntu() {
  LINUX_SYSTEM=`lsb_release -d -s | grep 14.04`
  ret=$?
  if [ x$ret != "x0" ]; then
    system_check_error
  fi
}

system_check_ubuntu
