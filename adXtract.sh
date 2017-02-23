#!/bin/bash



printf "\33c"

if [ -z $2 ]; then

        echo "usage: $0  ntds.dit SYSTEM";

        exit 1;

fi

CWD="$(pwd)"
echo "the working dir is " $CWD
mkdir '/root/Desktop/adXtract'.$3
mkdir '/root/Desktop/adXtract/Maps'

cd $CDW resources/libesedb-20160622/esedbtools

echo "This could take a while... time for coffee!"

./esedbexport -t /root/Desktop/adXtract/$3 $1 > /root/Desktop/adXtract/exported

cd ../../../

cd $CDW resources/ntdsxtract/

./dsusers.py /root/Desktop/adXtract/$3.export/datatable.3 /root/Desktop/adXtract/$3.export/link_table.5 /root/Desktop/adXtract/Maps/ --passwordhashes --pwdformat ophc --syshive $2 --lmoutfile /root/Desktop/adXtract/allLMhashes.txt --ntoutfile /root/Desktop/adXtract/allNTLMhashes.txt

cat /root/Desktop/adXtract/allNTLMhashes.txt
echo "Check /root/Desktop/adXtract/allLMhashes.txt"

