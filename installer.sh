#!/bin/bash

cd resources/libesedb-20160622/
chmod +x configure
./configure
make
cd resources/ntdsxtract2/
chmod +x *.py

echo "Configuration has completed"
echo "run adXtract.sh /pathto/ntds.dit /pathto/SYSTEM /ProjectName


