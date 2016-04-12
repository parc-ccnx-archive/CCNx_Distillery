#!/bin/bash

working_dir=`pwd`
script_dir=$(dirname "$BASH_SOURCE")

cd "${script_dir}"/../../

env=`make -f Makefile -s env`
for def in $env; do
	{ export $def; }
done	

cd "$working_dir"
