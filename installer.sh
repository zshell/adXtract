#!/bin/bash
CWD="$(pwd)"
cd resources/
tar xf libesedb-20160622.tar.gz
cd libesedb-20160622
./configure
make
cd $CWD resources/
cd ntdsxtract2/
chmod +x *.py

echo "Configuration has completed"
echo "run adXtract.sh /pathto/ntds.dit /pathto/SYSTEM /ProjectName"


