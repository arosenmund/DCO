$computers = Get-Content -Path "\computernames.txt"
$c =  $computers.count

Function Speak_It([string]$text){
                                    Add-Type -AssemblyName System.speech
                                    $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
                                    $speak.SelectVoice('Microsoft Zira Desktop')
                                    $speak.Speak($text)  
                            }

speak_it("Starting patch sequence on $c devices.")

Write-host "Starting patch sequence on $c devices."

foreach($computer in $computers)


    {
    Write-host "Creating Patch Sequence Job for $computer."
    $o = 1
    write-progress -Activity "Running Patch Sequence." -Status "Starting job for $computer" -PercentComplete ($o/$c)
    #start-job  
    
    Start-Job -Name "Running Patch Sequence $computer" -ArgumentList $computer -ScriptBlock {

                                                                                                    If(Test-Connection $computer -Quiet )
                                                                                                    #future upgrade, test-connection relies on icmp echo replies (ping) but this is often disabled on windows devices. 
                                                                                                    #"(Test-NetConnection -ComputerName 132.50.241.19 -CommonTCPPort SMB).TcpTestSucceeded" is higher efficacy.
                                                                                                    {
                                                                                                    $d = (Get-date).DateTime
                                                                                                    $s1 = "$d | Starting on $computer"
                                                                                                    Write-Host $s1 -ForegroundColor Cyan
                                                                                                    $s1 | out-file ./patching-sequence.txt -Append
                                                                                                    Set-Service WinRM -ComputerName $computer -StartupType Automatic -Verbose -PassThru
                                                                                                    $s2 = "$d | WinRM Set waiting for service to start $computer"
                                                                                                    Write-Host $s2 -ForegroundColor DarkYellow
                                                                                                    $s2 | out-file ./patching-sequence.txt -Append
                                                                                                    while($a -lt 10){
                                                                                                   
                                                                                                    $service_status = Get-Service -ComputerName $computer winrm
                                                                                                    $status = $service_status.status
                                                                                                    if($status -ne 'Running'){
                                                                                                                                start-sleep 10
                                                                                                                                $a++
                                                                                                                                }
                                                                                                                                else{$a = 10} #time bound otherwise it will just hang here.
                                                                                                                            }
                                                                                                    $d = (Get-date).DateTime
                                                                                                    $s3 = "$d | WinRM Running $computer"
                                                                                                    Write-Host $s3  -ForegroundColor Green
                                                                                                    $s3 | out-file ./patching-sequence.txt -Append
                                                                                                    Invoke-Command -ComputerName $computer -ScriptBlock {& C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe "Get-ChildItem -Path 'cert:\LocalMachine\Remote Desktop' | Remove-Item"} -ErrorAction SilentlyContinue
                                                                                                    $d = (Get-date).DateTime
                                                                                                    $s4 = "$d | Finished $computer"
                                                                                                    Write-Host $s4  -ForegroundColor Green
                                                                                                    $s4 | out-file ./patching-sequence.txt -Append
                                                                                                    Write-Host 'Finished' $computer -ForegroundColor Cyan
                                                                                                    }
                                                                                                    else 
                                                                                                    {

                                                                                                    $d = (Get-date).DateTime
                                                                                                    $s5 = "$d | $computer Offline"
                                                                                                    Write-Host $s5  -ForegroundColor Green
                                                                                                    $s5 | out-file ./patching-sequence.txt -Append
                                                                                                    
                                                                                                    Write-Host $s5 -ForegroundColor Red

                                                                                                    }
                                                                            }


        #memtest before starting next job in foreach loop
        $memuse = Get-Counter -counter "\memory\% committed bytes in use"
        $percmem = $memuse.CounterSamples.cookedvalue
        write-host "Current mem usage is $percmem percent."
        While($percmem -gt 80){

                            write-host "Mem is too high....throttling for you pleasure."; start-sleep 1
                            $memuse = Get-Counter -counter "\memory\% committed bytes in use"
                            $percmem = $memuse.CounterSamples.cookedvalue
                            write-host "Current mem usage is $percmem percent."
                           }
        #Increment counter for percentage bar
        $o++
        Write-host "Patch sequence start in background task for $computer."

    }

    speak_it("Patch sequence complete on all computers.")
