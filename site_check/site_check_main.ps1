#############Testing Route Validity#################
###th3m3ch4nic
##Website Testing / Remote Site Testing

#####Global Vars
$dt = (get-date).DateTime
$data_store = "C:\site_check\data_store\"
$baseline_store = "C:\site_check\baselines\"
$wait = 30
$site = ""
#comment out what you don't need


###Create Baselines

#Baseline
function create-baseline($site){
write-host "Creating provded site baseline!" -ForegroundColor white -BackgroundColor Green
write-host "Initiating latency average test using 30 count." -BackgroundColor Cyan -ForegroundColor White
$lt = test-connection -count 30  -ComputerName $site
$lt_total = 0
foreach($l in $lt.responsetime){
    $lt_total += $l
}
$lt = $lt_total/$lt.count
[math]::round($lt) |export-clixml $baseline_store\baseline_latency.xml

write-host "Initiating ttl baseline test." -BackgroundColor Cyan -ForegroundColor White

$ttl =test-connection -count 1 -ComputerName $site
$ttl = $ttl.ResponseTimeToLive
$ttl |export-clixml $baseline_store\baseline_ttl.xml

write-host "Initiating traceroute baseline for hops." -BackgroundColor Cyan -ForegroundColor White


$hops = test-netconnection -traceroute $site
$hops.TraceRoute.count |export-clixml $baseline_store\baseline_hops.xml

write-host "Initiating traceroute for hashing of prefered route." -BackgroundColor Cyan -ForegroundColor White

$route = test-netconnection -traceroute $site
$route = $route.traceroute
$i = $route.count - 2
$route = $route[0..$i]
$route| export-clixml $baseline_store\baseline_route.xml
$route_base_hash = get-filehash "C:\site_check\baselines\baseline_route.xml"
$route_base_hash.hash |export-clixml $baseline_store\baseline_route_hash.xml

write-host "Initiating DNS response hash baseline." -BackgroundColor Cyan -ForegroundColor White

$dns = Resolve-DnsName -Name $site -DnsOnly -NoHostsFile
$dns |select Name,Type,Section,Ipaddress|Sort-Object IPAddress| export-clixml $baseline_store\baseline_dns.xml
}

####################################################################


###All Tests####################
function run-webtest($site){
$run = $true
while($run -eq $true){
write-host "Testing for web response value." -BackgroundColor Cyan -ForegroundColor White

$web_test = invoke-webrequest -uri $site
$web_test.statuscode | export-clixml $data_store\web_test.xml

#latency test
write-host "Testing latency." -BackgroundColor Cyan -ForegroundColor White

$lt = test-connection -count 10  -ComputerName $site
$lt_total = 0
foreach($l in $lt.responsetime){
    $lt_total += $l
}
$lt = $lt_total/$lt.count
[math]::round($lt) |export-clixml $data_store\latency_test.xml

#ttl test
write-host "Testing testing ping response TTL." -BackgroundColor Cyan -ForegroundColor White

$ttl =test-connection -count 1 -ComputerName $site
$ttl = $ttl.ResponseTimeToLive
$ttl |export-clixml $data_store\ttl_test.xml

#hops test
write-host "Testing for web response value." -BackgroundColor Cyan -ForegroundColor White

$hops = test-netconnection -traceroute $site
$hops.TraceRoute.count |export-clixml $data_store\hops_test.xml
$hops = $hops.traceroute.count

write-host "Total hops equals $hops." -BackgroundColor Green -ForegroundColor white

#route test###careful here with multiple endpoints or source with multi nat
write-host "Testing for route consistency." -BackgroundColor DarkGreen -ForegroundColor White

$route_base_hash = Import-Clixml C:\site_check\baselines\baseline_route_hash.xml


$route_current = Test-NetConnection -TraceRoute -ComputerName $site
$route_current = $route_current.TraceRoute
$i = $route_current.count - 2
$route_current = $route_current[0..$i] 
$route_current|export-clixml $data_store\route_test.xml
$route_current_hash = Get-FileHash $data_store\route_test.xml

if($route_current_hash.hash -eq $route_base_hash){$route_consistent = 1}else{$route_consistent = 0}
$route_consistent |export-clixml $data_store\route_consistent.xml
write-host "Route baseline hash is $route_base_hash and the current route hash is $route_current_hash." -background DarkYellow -ForegroundColor White

######DNS Resolution Status####
write-host "Testing DSN resolution consistency." -BackgroundColor Darkgreen -ForegroundColor white
$dns_current = Resolve-DnsName -name $site -DnsOnly -NoHostsFile
$dns_current|select Name,Type,Section,Ipaddress |Sort-Object IPAddress|export-clixml $data_store\dns_test.xml

$dns_base_hash = (get-filehash $baseline_store\baseline_dns.xml).hash
$dns_current_hash = (get-filehash $data_store\dns_test.xml).hash

if($dns_base_hash -eq $dns_current_hash){$dns_consistent = 1}else{$dns_consistent = 0}
$dns_consistent |export-clixml $data_store\dns_consistent.xml
write-host "DNS baseline hash is $dns_base_hash and the current route hash is $dns_current_hash." -background Yellow -ForegroundColor White


######Route Status#############
write-host "Tests complete @$dt...wating $wait seconds before repeating."

start-sleep -seconds $wait
}
}
