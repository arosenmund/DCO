#AD-Scan and Dump
    [CmdletBinding( 
        SupportsShouldProcess=$True, 
        ConfirmImpact="Low" 
    )] 
    param 
    ( 
        [String]$Ldap = "dc="+$env:USERDNSDOMAIN.replace(".",",dc=")#,         
        [String]$Filter = "(&(objectCategory=person)(objectClass=user)(displayname=* Gen *))" 
    ) 
 
    Begin{} 
 
    Process 
    { 
        if ($pscmdlet.ShouldProcess($Ldap,"Get information about AD Object")) 
        { 
            $searcher=[adsisearcher]$Filter 
             
            $Ldap = $Ldap.replace("LDAP://","") 
            $searcher.SearchRoot="LDAP://$Ldap" 
            $results=$searcher.FindAll() 
     
            $ADObjects = @() 
            foreach($result in $results) 
            { 
                [Array]$propertiesList = $result.Properties.PropertyNames 
                $obj = New-Object PSObject 
                foreach($property in $propertiesList) 
                {  
                    $obj | add-member -membertype noteproperty -name $property -value ($result.Properties.Item($property)) 
                } 
                $ADObjects += $obj 
            } 
       
            Return $ADObjects 
        } 
    } 
     
    End{} 
    $date = get-date -format filedatetime

    $adobjects | export-clixml C:\Users\1460539567N\Desktop\AD-Tracker\GEN-$date.XML
     
