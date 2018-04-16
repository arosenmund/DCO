$domain = read-host "input fully qualified domain ex. "AREA52.AFNOAPPS.USAF.MIL""
$user = read-host "user folder name"


get-childitem  -Recurse -Filter name -like "*.vbs*" -Path "\\$domain\sysvol\"


#Search for file types #add loading bar

$txt_files = get-childitem -Filter "*.txt*" -Recurse -Path "\\$domain\sysvol\"

$vbs_files = get-childitem -Filter "*.vbs*" -Recurse -Path "\\$domain\sysvol\"

$bat_files = get-childitem -Filter "*.bat*" -Recurse -Path "\\$domain\sysvol\"

$ps1_files = get-childitem -Filter "*.ps1*" -Recurse -Path "\\$domain\sysvol\"

##########################################

$txt_files2 = get-childitem -Filter "*.txt*" -Recurse -Path "\\$domain\netlogon"

$vbs_files2 = get-childitem -Filter "*.vbs*" -Recurse -Path "\\$domain\sysvol\"

$bat_files2 = get-childitem -Filter "*.bat*" -Recurse -Path "\\$domain\sysvol\"

$ps1_files2 = get-childitem -Filter "*.ps1*" -Recurse -Path "\\$domain\sysvol\"




#search for strings in file types

    #user.name@domain.com
    $reg_user = '\b[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,6}\b'
    select-string -path $txt_files -Pattern $reg_user
    select-string -path $bat_files -Pattern $reg_user
    select-string -path $vbs_files -Pattern $reg_user
    select-string -path $ps1_files -Pattern $reg_user
    select-string -path $txt_files2 -Pattern $reg_user
    select-string -path $bat_files2 -Pattern $reg_user
    select-string -path $vbs_files2 -Pattern $reg_user
    select-string -path $ps1_files2 -Pattern $reg_user

    #password
    $reg_pw = '\bpw\b'
    select-string -path $txt_files -Pattern $reg_pw
    select-string -path $bat_files -Pattern $reg_pw
    select-string -path $vbs_files -Pattern $reg_pw
    select-string -path $ps1_files -Pattern $reg_pw
    select-string -path $txt_files2 -Pattern $reg_pw
    select-string -path $bat_files2 -Pattern $reg_pw
    select-string -path $vbs_files2 -Pattern $reg_pw
    select-string -path $ps1_files2 -Pattern $reg_pw

    #.admin
    $reg_admin = '\b\.admin\b'
    select-string -path $txt_files -Pattern $reg_admin 
    select-string -path $bat_files -Pattern $reg_admin
    select-string -path $vbs_files -Pattern $reg_admin
    select-string -path $ps1_files -Pattern $reg_admin
    select-string -path $txt_files2 -Pattern $reg_admin 
    select-string -path $bat_files2 -Pattern $reg_admin
    select-string -path $vbs_files2 -Pattern $reg_admin
    select-string -path $ps1_files2 -Pattern $reg_admin

    #shortname\user.name




$input_path ='c:\ps\emails.txt'
$output_file=

$regex='\b[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,6}\b'


select-string -Path $input_path -Pattern $regex -AllMatches |%{$_.Matches}|%{$_.Value} > $output_file



$inputtest = "C:\Users\$user\Desktop\UserDomain.txt"




select-string -Path $inputtest -Pattern $reg_pw
