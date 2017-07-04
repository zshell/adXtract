cls

Write-Host @"
            ___  ___                  _   
   __ _  __| \ \/ / |_ _ __ __ _  ___| |_ 
  / _` |/ _` |\  /| __| '__/ _` |/ __| __|
 | (_| | (_| |/  \| |_| | | (_| | (__| |_ 
  \__,_|\__,_/_/\_\\__|_|  \__,_|\___|\__|
                                          
"@ -fo green

$cwd = (Resolve-Path .\).Path
Write-Host $cwd -fo red

#Setting up the Config File for first time run:
Write-Host "Setting up Config file" -fo yellow
If(Test-Path .\config.txt) {
$HCPath = get-content ".\config.txt" | select-string -pattern hashcat
$Esedb =  get-content ".\config.txt" | select-string -pattern win_libesedb 
$python = get-content ".\config.txt" | select-string -pattern Python
$words = get-content ".\config.txt" | select-string -pattern wordlists
$rules = get-content ".\config.txt" | select-string -pattern rules 
} Else {
$HCPath = Read-Host "Where is Hashcat64.exe"
$Esedb = Read-Host "Where is esedbexport.exe"
$python = Read-Host "Where is python.exe"
$words = Read-Host "Where are your wordlists?"
$rules = Read-Host "Where are your hashcat rules?"
}

#Checking if config exists do not overwrite:
If(Test-Path .\config.txt) { } Else {
"$HCPath" | Out-File -FilePath "$cwd\config.txt" -Encoding utf8
"$Esedb" | Out-File -FilePath "$cwd\config.txt" -Append -Encoding utf8
"$python" | Out-File -FilePath "$cwd\config.txt" -Append -Encoding utf8
"$words" | Out-File -FilePath "$cwd\config.txt" -Append -Encoding utf8
"$rules" | Out-File -FilePath "$cwd\config.txt" -Append -Encoding utf8
}

#Extracting the NTDS.dit:
Write-Host "Config Set" -fo yellow
$DBpath = Read-Host "Enter path to the ntds.dit and SYSTEM files"

#Extracting the table information:
Write-host "Extracting table information" -fo Yellow
Write-Host @"
############################
"@ -fo green

cmd /c "$Esedb\esedbexport.exe" "$DBPath\ntds.dit"
mv ntds.dit.export $DBPath

#Extracting User hashes and historic hashes into Hashcat format:
Write-host "Extracting ntds, this can take a while" -fo red
cmd /c "$python\python.exe" "$cwd\resources\ntdsxtract2\dsusers.py" "$DBPath\ntds.dit.export\datatable.3" "$DBPath\ntds.dit.export\link_table.5" "$DBpath\ntds.dit.export" --passwordhashes --pwdformat ophc --syshive "$DBpath\SYSTEM" --passwordhistory --ntoutfile "$DBPath\hashes-humanreadable.hash"

#Crackng passwords using hashcat: 
cmd /c "$HCPath\hashcat64.exe" -m 1000 "$DBPath\hashes-humanreadable.hash" "$words\*.txt" -w3 --rules "$rules\1_top_500.rule"

pause 
