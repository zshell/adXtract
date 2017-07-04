cls

Write-host "            ___  ___                  _   "
Write-host "   __ _  __| \ \/ / |_ _ __ __ _  ___| |_ "
Write-host "  / _` |/ _` |\  /| __| '__/ _` |/ __| __|"
Write-host " | (_| | (_| |/  \| |_| | | (_| | (__| |_ "
Write-host "  \__,_|\__,_/_/\_\\__|_|  \__,_|\___|\__|"
Write-host "                                          "


$ntds = "$DBpath\ntds.dit"
$pkey = "$DBpath\SYSTEM"
$Pthexe = "$python\python.exe"
$cwd = (Resolve-Path .\).Path


Write-Host "Setting up Config file"
If(Test-Path .\config.txt) {get-content ".\config.txt" | select-string -pattern hashcat } Else { $HCPath = Read-Host "Where is Hashcat64.exe" }  
If(Test-Path .\config.txt) {get-content ".\config.txt" | select-string -pattern win_libesedb } Else { $Esedb = Read-Host "Where is esedbexport.exe"}
If(Test-Path .\config.txt) {get-content ".\config.txt" | select-string -pattern Python } Else { $python = Read-Host "Where is python.exe"}
If(Test-Path .\config.txt) {get-content ".\config.txt" | select-string -pattern wordlists } Else { $words = Read-Host "Where are your wordlists? "}
If(Test-Path .\config.txt) {get-content ".\config.txt" | select-string -pattern rules } Else { $rules = Read-Host "Where are your hashcat rules? "}

"$HCPath" | Out-File -FilePath "$cwd\config.txt" -Encoding utf8
"$Esedb" | Out-File -FilePath "$cwd\config.txt" -append -Encoding utf8
"$python" | Out-File -FilePath "$cwd\config.txt" -append -Encoding utf8
"$words" | Out-File -FilePath "$cwd\config.txt" -append -Encoding utf8
"$rules" | Out-File -FilePath "$cwd\config.txt" -append -Encoding utf8

Write-Host "Config Set"
$DBpath = Read-Host "Enter path to the ntds.dit and SYSTEM files"

Write-host "Extracting table information"
# Extract hashes
cmd /c "$Esedb\esedbexport.exe" "$DBPath\ntds.dit"
mv ntds.dit.export $DBPath


Write-host "Extracting ntds, this can take a while"
cmd /c "$python\python.exe" "$cwd\adXtract\resources\ntdsxtract2\dsusers.py" "$DBPath\ntds.dit.export\datatable.3" "$DBPath\ntds.dit.export\link_table.5" "$DBpath\ntds.dit.export" --passwordhashes --pwdformat ophc --syshive $pkey --passwordhistory --ntoutfile "$DBPath\hashes-humanreadable.hash"
#cmd /c "$Pthexe" "$cwd\adXtract\resources\ntdsxtract2\dsusers.py" $DBPath\ntds.dit.export\datatable.* $DBPath\ntds.dit.export\link_table.* --members --csvoutfile $DBPath\GroupMembershipOut.csv
#mv $DBPath\hashes-humanreadable.hash $cwd\hashes-humanreadable.hash
cmd /c "$HCPath\hashcat64.exe" -m 1000 "$DBPath\hashes-humanreadable.hash" "$words\*.txt" -w3 --rules "$rules\1_top_500.rule"

pause 
