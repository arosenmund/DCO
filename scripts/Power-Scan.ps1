####themechanic

<#
.SYNOPSIS
    This script loads the three following functions for use:
    start-subnetscan    :scans the specified subnet for endpoints and commonports
    start-endpointscan  :scans the specified endpoint on the range of ports provided
    start-networkscan   :scans for the existence of other networks and maps the number of hops
.DESCRIPTION
    Currently only start-subnet scan properly works.  When ran it will ask for the first 3 octets of the subnet you would like to scan.
    This is meant to scan within a class C or smaller.  Follow the first 3 octets with a '.' as instructed.  You will then be prompted
    for the begining IP of the range (the fourth octet -->title of a sci-fi novel I will write one day) and the ending IP for the range.
    The scan will then begin. Each IP scanned is ran in separate job while the memory is monitored to ensure it does not exceed safe
    parameters.  If the memory does exceed the hard coded parameters it will stop spawning jobs until the the memory usage has dropped to
    a safe range. 
.NOTES
    start-endpoint scan will be operational in the next release followed by start-networkscan
.LINK
    https://github.com/arosenmund/DCO
.EXAMPLE
    powershell powerscan.ps1   <---duh
#>


write-host "
______   ______  _  __ ___________            ______ ____ _____    ____  
\____ \ /  _ \ \/ \/ // __ \_  __ \  ______  /  ___// ___\\__  \  /    \ 
|  |_> >  <_> )     /\  ___/|  | \/ /_____/  \___ \\  \___ / __ \|   |  \
|   __/ \____/ \/\_/  \___  >__|            /____  >\___  >____  /___|  /
|__|                      \/                     \/     \/     \/     \/ 

"

write-host "
___.          
\_ |__ ___.__.
 | __ <   |  |
 | \_\ \___  |
 |___  / ____|
     \/\/   
"


write-host "
__  .__              _____                .__                  .__        
_/  |_|  |__   ____   /     \   ____   ____ |  |__ _____    ____ |__| ____  
\   __\  |  \_/ __ \ /  \ /  \_/ __ \_/ ___\|  |  \\__  \  /    \|  |/ ___\ 
 |  | |   Y  \  ___//    Y    \  ___/\  \___|   Y  \/ __ \|   |  \  \  \___ 
 |__| |___|  /\___  >____|__  /\___  >\___  >___|  (____  /___|  /__|\___  >
           \/     \/        \/     \/     \/     \/     \/     \/        \/ 
"


#subnetscan
function start-subnetscan( $first_three ){

$current_dir = get-location
$current_dir.path

write-verbose "Welcome to power-scan the least creative name th3m3ch4nic could think of, but alas we can't choose our parents."

#First step run according to input, display results in chart.  One off capability.
#Next step, run off of generated configuration file.  Store data in the collection per network and use change tracking dashboard.
#Subnet Comparison
    $report = @() #initialize memory space for the 

    get-job|remove-job #removes jobs from last run

    #first octet
    $first_three = read-host "Please enter the  frist 3 octets of network to be scanned with a '.' at the end.  
    Like so:  Examples: 192.168.1."


    #last octet
    $Starting_IP = read-host "Enter starting ip (last octet)"
    $Ending_IP= read-host "Enter ending ip (last octet)"

    #Maybe some sort of range of ports option here?

    $iprange = $Starting_IP..$Ending_IP

###need to add progress bar###

Foreach( $ip in $iprange){
    $c = $iprange.count
    $o = 1

    write-progress -Activity "Scanning the input range." -Status "Starting job for $ip"  -PercentComplete ($o/$c)
    
    $I = $first_three+[string]$ip

    Start-Job -Name "Testing $I" -ArgumentList $I -ScriptBlock {
    Try {$name = [System.net.DNS]::GetHostByAddress($args[0])|select-object HostName -ErrorAction Continue}catch{write-host "Input null or non resolved"}

    #Try {icmp_response = test-netconnection -port $port_TCP -InformationLevel Quiet -ComputerName $I  -erroraction Continue}catch{write-verbose "blip blop"}
    Try {$response = test-connection -quiet -Count 1 -ComputerName $args[0]  -erroraction Continue}catch{write-host "ICMP response failed to $args[0]"}
            if($response -eq $true){$more = test-connection -count 1 -ComputerName $args[0]}
    Try {$SMB_response = Test-NetConnection -ComputerName $args[0] -CommonTCPPort SMB -InformationLevel Quiet -ErrorAction Continue}catch{write-host "SMB Connection failed to $args[0]"}
    Try {$RDP_response = Test-NetConnection -ComputerName $args[0] -CommonTCPPort RDP -InformationLevel Quiet -ErrorAction Continue}catch{write-host "RDP Connection failed to $args[0]"}
    Try {$WINRM_response = Test-NetConnection -ComputerName $args[0] -CommonTCPPort WINRM -InformationLevel Quiet -ErrorAction Continue}catch{write-host "WINRM Connection failed to $args[0]"}    
    Try {$HTTP_response = Test-NetConnection -ComputerName $args[0] -CommonTCPPort HTTP -InformationLevel Quiet -ErrorAction Continue}catch{write-host "HTTP Connection failed to $args[0]"}
            #if($SMB_response -eq $true -or $RDP_response -eq $true -or $WINRM_respone -eq $true -or $HTTP_response -eq $true){
            #        Port_scan($I)
            #}

    $properties = @{

                IP4_Address = $args[0]
                Computer_Name = $name.HostName
                Response_Status = $response
                Time_to_Live = $more.responsetimetolive
                Response_time = $more.responsetime
                SMB_Status = $SMB_response
                RDP_Status = $RDP_response
                HTTP_Status = $WINRM_response
                WINRM_Status = $HTTP_response

                }

    new-object -TypeName psobject -Property $properties
    
    }



    $memuse = Get-Counter -counter "\memory\% committed bytes in use"
    $percmem = $memuse.CounterSamples.cookedvalue
    write-host "Current mem usage is $percmem percent."
    While($percmem -gt 80){

                            write-host "Mem is too high....throttling for you pleasure."; start-sleep 1
                            $memuse = Get-Counter -counter "\memory\% committed bytes in use"
                            $percmem = $memuse.CounterSamples.cookedvalue
                            write-host "Current mem usage is $percmem percent."
                           }
    $o++
}

#####need to wait for all jobs to finish cyclically then recieve them and add them to the report.

$report = get-job |receive-job -Wait -AutoRemoveJob

$date = get-date -format dd_MM_yy_HHmmss

$report |Export-Clixml -path $current_dir/$first_three-$date.xml

$report |convertto-html |out-file $current_dir/$first_three.html

}



#########################################Range port scanner^^^^^build into above function^^^^^^#########################
#####scan one ip for a range of ports
function start-endpointscan($ip,$starting_port,$Ending_Port){

    $current_dir = get-location
    $current_dir.path
 
    $portrange = $Starting_Port..$Ending_Port

    Foreach( $port in $portrange){

       test-netconnection -port $port -InformationLevel Quiet -ComputerName $IP
      
    }


}
####################################Network Detection######################################################################
function start-networkscan(){


#what other networks are there?
$networks_report = @()
#first 2 octet
$first_two = "131.55."
#last octet
$Starting_IP = 1
$Ending_IP= 254
$network = ".1"
$iprange = $Starting_IP..$Ending_IP


Foreach( $ip in $iprange){
    
    $I = $first_two+[string]$ip +$network
    write-host "Trying network id $I"
    #Try {icmp_response = test-netconnection -port $port_TCP -InformationLevel Quiet -ComputerName $I  -erroraction Continue}catch{write-verbose "blip blop"}
    Try {$response = test-connection -quiet -Count 1 -ComputerName $I  -erroraction Continue}catch{write-host "ICMP response failed to $I"}
            if($response -eq $true){$more = test-connection -count 1 -ComputerName $I}
            #if($SMB_response -eq $true -or $RDP_response -eq $true -or $WINRM_respone -eq $true -or $HTTP_response -eq $true){
            #        Port_scan($I)
            #}

    $properties = @{

                IP4_Address = $I
                Computer_Name = $name.HostName
                Response_Status = $response
                Time_to_Live = $more.responsetimetolive
                Response_time = $more.responsetime
                }

    $obj = new-object -TypeName psobject -Property $properties
    $networks_report += $obj

}

$networks_report |convertto-html | out-file ~/networks131.55.html
}