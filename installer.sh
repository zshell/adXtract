#!/bin/bash
CWD="$(pwd)"
cd resources/
tar xf libesedb-20160622.tar.gz
cd libesedb-20160622
./configure
make
printf "\033c"
echo "Configuration has completed"
echo "run adXtract.sh /pathto/ntds.dit /pathto/SYSTEM /ProjectName"

