#function power-scan( $first_three ){

#Subnet Comparison
$networks_report = @()
#first octet
$first_three = "131.55.192."
#last octet
$Starting_IP = 43
$Ending_IP= 254
$port_TCP = 445
$iprange = $Starting_IP..$Ending_IP
Foreach( $ip in $iprange){
    
    $I = $first_three+[string]$ip

    Try {$name = [System.net.DNS]::GetHostByAddress($I)|select HostName -ErrorAction Continue}catch{write-host "Input null or non resolved"}

    #Try {icmp_response = test-netconnection -port $port_TCP -InformationLevel Quiet -ComputerName $I  -erroraction Continue}catch{write-verbose "blip blop"}
    Try {$response = test-connection -quiet -Count 1 -ComputerName $I  -erroraction Continue}catch{write-host "ICMP response failed to $I"}
            if($response -eq $true){$more = test-connection -count 1 -ComputerName $I}
    Try {$SMB_response = Test-NetConnection -ComputerName $I -CommonTCPPort SMB -InformationLevel Quiet -ErrorAction Continue}catch{write-host "SMB Connection failed to $I"}
    Try {$RDP_response = Test-NetConnection -ComputerName $I -CommonTCPPort RDP -InformationLevel Quiet -ErrorAction Continue}catch{write-host "RDP Connection failed to $I"}
    Try {$WINRM_response = Test-NetConnection -ComputerName $I -CommonTCPPort WINRM -InformationLevel Quiet -ErrorAction Continue}catch{write-host "WINRM Connection failed to $I"}    
    Try {$HTTP_response = Test-NetConnection -ComputerName $I -CommonTCPPort HTTP -InformationLevel Quiet -ErrorAction Continue}catch{write-host "HTTP Connection failed to $I"}
            #if($SMB_response -eq $true -or $RDP_response -eq $true -or $WINRM_respone -eq $true -or $HTTP_response -eq $true){
            #        Port_scan($I)
            #}

    $properties = @{

                IP4_Address = $I
                Computer_Name = $name.HostName
                Response_Status = $response
                Time_to_Live = $more.responsetimetolive
                Response_time = $more.responsetime
                SMB_Status = $SMB_response
                RDP_Status = $RDP_response
                HTTP_Status = $WINRM_response
                WINRM_Status = $HTTP_response

                }

    $obj = new-object -TypeName psobject -Property $properties
    $report += $obj

}

$report |convertto-html |out-file ~/$first_three.html

#####scan one ip for a range of ports
$IP = "131.55.192.66"

$Starting_Port = 1
$Ending_Port= 1024

 
$portrange = $Starting_Port..$Ending_Port



Foreach( $port in $portrange){

    $I = $first_three+[string]$ip
    test-netconnection -port $port -InformationLevel Quiet -ComputerName $IP

}





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
