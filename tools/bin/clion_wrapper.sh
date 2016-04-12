#!/bin/bash
script_dir=$(dirname "$BASH_SOURCE")

export DISTILLERY_BUILD_NAME=-debug

cd "${script_dir}"
source ./export_ccnx_env.sh

cd ${DISTILLERY_ROOT_DIR}/src

osType=`uname -s`

case "$osType" in
	Darwin)
		open /Applications/CLion.app
		;;
	Linux)
		clion.sh
		;;
	*)
		echo "System not recognized, edit ${0} to add support"
		;;
esac

