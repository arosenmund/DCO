$signins = import-csv ".\InteractiveSignIns_2020-10-15_2020-10-16.csv"
$f_signins = $signins | Select-Object -Property User, "Date (UTC)", Location, 'IP address'
$s_signins = $f_signins | Sort-Object "Date (UTC)"
$s_signins = $s_signins | Sort-Object User



#convert to usable dates
#separate portions of Location

$a = @()

foreach ($s in $s_signins){

[datetime]$dateTime = $s.'Date (UTC)'

$l = $s.location.split(", ")
$city = $l[0]
$state = $l[1]
$country = $l[2]

$properties = [ordered]@{
                            User = $s.User
                            DT = $dateTime
                            City = $city
                            State = $state
                            Country = $country
                            IP = $s.'IP address'
                        }

$b = new-object -TypeName psobject $properties

$a += $b

}
#DETECTIONS!


#Check for impossible travel
#sort users
$users = $a.user | sort-object -unique

Foreach($u in $users){
    $last = $null
    $user_set = $a | where-object -Property user -EQ $u
    $user_set = $user_set |Sort-Object DT
    foreach($login in $user_set){
        If($last -eq $null){$last = $login}
        elseif($login.state -eq $last.state){
            write-host "Same login location, checking next." -ForegroundColor Green
            $last = $login
        }else{
            
            $td = $last.DT - $login.DT

            if($td.Days -lt 1 -and $td.Hours -lt 1 -and $td.Minutes -lt 30){
                $location = $login.city+", "+$login.state+", "+$login.country
                Write-warning "Potential Impossible Travel Alert! From $location for user $u "
            }
            
        }
    }

}




