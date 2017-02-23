#!/bin/bash
CWD="$(pwd)"
tar xf $CWD resources/libesedb-20160622.tar.tar.gz -C $CWD resources/libesedb-20160622
cd $CWD resources
./configure
make
cd resources/ntdsxtract2/
chmod +x *.py

echo "Configuration has completed"
echo "run adXtract.sh /pathto/ntds.dit /pathto/SYSTEM /ProjectName


