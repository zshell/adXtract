#!/bin/bash
printf "\33c"

if [ -z $3 ]; then

        echo 'usage: /location of/ntds.dit /location of/SYSTEM ProjectName';

        exit 1;

fi
CWD="$(pwd)"
echo 'the working dir is ' $CWD
mkdir $CWD'/adXtract_'$3
mkdir $CWD'/adXtract_'$3'/Maps'
cd $CDW resources/libesedb-20160622/esedbtools
echo 'This could take a while... time for coffee!'
./esedbexport -t $CWD/adXtract_$3/$3 $1 > $CWD/adXtract_$3/exported
cd ../../
cd $CWD 
echo $CWD
cd resources/ntdsxtract2/
./dsusers.py $CWD/adXtract_$3/$3.export/datatable* $CWD/adXtract_$3/$3.export/link_table* $CWD/adXtract_$3/Maps/ --passwordhashes --pwdformat ophc --syshive $2 --lmoutfile $CWD/adXtract_$3/$3_allLMhashes.txt --ntoutfile $CWD/adXtract_$3/$3_allNTLMhashes.txt --csvoutfile $CWD/adXtract_$3/$3_UserAccountOut.csv
./dsgroups.py $CWD/adXtract_$3/$3.export/datatable* $CWD/adXtract_$3/$3.export/link_table* $CWD/adXtract_$3/Maps/ --members --csvoutfile $CWD/adXtract_$3/$3_GroupMembershipOut.csv
cat $CWD/adXtract_$3/$3_allNTLMhashes.txt
echo "$CWD/adXtract."$3"/"$3"allLMhashes.txt"
