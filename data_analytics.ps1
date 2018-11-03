######Master Data Analysis Script######
###th3m3ch4nic


#globals

$path = "F:\DCO\" 


##load up inputs and current status##


##powerscan import
 
$scans = import-clixml -path F:\DCO\xml_store\power_scan\*

<#All reports included in this analytics script:
        -Scan Overview
        -Scan Detail
        -AD Overview
        -AD Detail
        #>


##Powerscan Outputs
###Build Scan Overview Report
##Queries

$total_active = ($scans |?{$_.Response_Status -eq $true}).count


#Query results into properties
$so_properties = @{
                    total_active = $total_active
                             }
#Create object to store all results

$Scan_Overview = new-object -TypeName psobject -property $so_properties

#export object
$date_time = get-date -format yyyyMMddHHmmss
$Scan_Overview |Export-Clixml -path F:\DCO\web_page\reports\scan_overview-$date_time.xml



#categroization of live machines by TTL

###windows machines

###nix machines

###network device

###unknown
 

##Total Active Scanned IP's Most Recent Scan


##AD scan outputs
##Total User Computers
##Total Server Computers
##Total Users Enabled
##Total Admins Enabled


#User Breakdown

#Computer Breakdown

