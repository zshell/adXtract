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
##############################
#For Status check the size of#
# the DataTable file within  #
#   /"ntds.dit.export/ "     #
#    Approx speed 300kb/s    # 
#############################
"@ -fo green

cmd /c "$Esedb\esedbexport.exe" "$DBPath\ntds.dit"



#Extracting User hashes and historic hashes into Hashcat format:
Write-host "Moving Files to Target Folder" -fo Yellow
Write-Host "##########################################" -fo green
mv ntds.dit.export $DBPath

$datat = Get-ChildItem -Path $DBpath\ntds.dit.export -Name | Select-String -Pattern datatable
$linkt = Get-ChildItem -Path $DBpath\ntds.dit.export -Name | Select-String -Pattern link_table

Write-host "# Extracting ntds, this can take a while #" -fo red
Write-Host "##########################################" -fo green
cmd /c "$python\python.exe" "$cwd\resources\ntdsxtract2\dsusers.py" "$DBPath\ntds.dit.export\$datat" "$DBPath\ntds.dit.export\$linkt" "$DBpath\ntds.dit.export" --passwordhashes --pwdformat ophc --syshive "$DBpath\SYSTEM" --passwordhistory --ntoutfile "$DBPath\hashes-humanreadable.hash"

Write-host "#########################"
Write-host "# Cracking Using Hashcat#" -fo Yellow
Write-host "#########################"-fo green
#Crackng passwords using hashcat: 
#cmd /c "$HCPath\hashcat64.exe" -m 1000 "$DBPath\hashes-humanreadable.hash" "$words\*.txt" -w3 --rules "$rules\1_top_500.rule"

pause 
