######Setup Script for DCO Forge
##th3m3ch3nic

####Global Variables

$working_root_dir = Get-Location


<#
Direcotries
root
---->web_page
---->scripts
---->xml_store
#>

##Get Current Network Address
$networks = @()
$done = 0
while($done -lt 1){



$net = read-host "Enter a network to scan(ex. 10.0.0.0)"

$sub = read-host "Enter the subnet in cider(ex. 24)"

$properties = @{
                Network = $net
                Subnet  = $sub
                Last_Scanned = $null
                }

$obj = new-object -TypeName psobject -property $properties

$networks+=$obj
$more = read-host "Are there more networks?(y/n)"
if($more -like "n"){$done = 1}

}

$networks | export-clixml -path $working_root_dir\settings\ps-scan-networks.xml

#Get & Store Networks to Scan

#Get & Store Active Directory Domain



