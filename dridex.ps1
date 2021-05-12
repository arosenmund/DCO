$proc = get-process

#Sample One look for wmic execution
#1 process commandline wmic match
$1 = "wmic.exe os get /format:"
# rundll32.exe
$2 = $proc | ?{$_.commandline -like "*rundll32.exe*"} | select *
# process names with parent execution 1
$3 = $proc|?{$_.name -like "*rundll32*" -and $_.parent -like "*wmic*"} | select *
# process commandline match for excel
$4 = $proc|?($_.commandline -like "*excel /dde*") | select *
$5 - $proc|?($_.commandline -like "*regsvr32.exe -s*") | select *
# process names with parent execution 2
$6 = $proc|?($_.name -like "*regsvr32*" -and $_.parent -like "*excel*")

if ($3) {write-warning "Dridex Inidcators Detected!"
write-host -ForegroundColor red $1
write-host -ForegroundColor red $2 
write-host -ForegroundColor red $3
}

if ($3) {write-warning "Dridex Inidcators Detected!"
write-host -ForegroundColor red $4
write-host -ForegroundColor red $5 
write-host -ForegroundColor red $6
}

if ($6) {write-warning "Dridex Inidcators Detected!"
write-host -ForegroundColor red $4
write-host -ForegroundColor red $5 
write-host -ForegroundColor red $6
}

write-host -ForegroundColor Green "All Indicators detected:
$1
$2
$3
$4
$5
$6
"




