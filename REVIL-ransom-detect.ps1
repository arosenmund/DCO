##Sodihibi Malware Checker
$evidence_dir = c:\investigation-$env:hostname

#hash table for dection


#event log before 2-17-20

$log_clear = get-winevent -LogName security -Oldest -MaxEvents 1

if($log_clear.id -eq 1102){
$log_check = 1
get-winevent -LogName security |out-file security-log-2018.txt

}else{$security_check = 0}

#check windows directory for directx.sys

if(Get-item c:\Windows\directx.sys){
$neshta_files = 1
write-host "directx.sys IS present - !!!INFECTED!!!" -BackgroundColor Red -ForegroundColor White

}else{

write-host "directx.sys not present - CLEAN" -BackgroundColor Green -ForegroundColor White
  
}

#svchost.com
if(Get-item c:\Windows\svchost.com){
$neshta_files = 1
write-host "scvhost.com IS present - !!!INFECTED!!!" -BackgroundColor Red -ForegroundColor White

}else{

write-host "scvhost.com not present - CLEAN" -BackgroundColor Green -ForegroundColor White

}



#get contents of folder

if(get-childitem "c:\folder"){

Compress-Archive -literalpath "c:\folder" -DestinationPath "c:\folder-$env:hostname.zip"

mv "c:\folder-$env:hostname.zip"

}

$properties= @(

        Cleared_logs = $Cleared_logs
        neshta_files = $neshta_files
        registry_persistenct = $reg_persistence 

)

$obj = New-Object -TypeName psobject -properties $properties


if(bad){
write-host "Collecting evidence"
#Run collection script for invoke-liveresponse



}
