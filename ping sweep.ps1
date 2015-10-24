Do{

$ping = New-Object System.Net.NetworkInformation.Ping 
$i = 0 
$classC = Read-Host 'Please enter the first three octets of the range you would like to scan or type quit to end'

if ($classC -eq 'quit') {break}
    else{

$first = Read-Host 'Please enter the first octect of the first IP in the scan range'
$last = Read-Host 'Please enter the last octect of the last IP in the scan range'

$first..$last | foreach { $ip = "$classC.$_"  
$Res = $ping.send($ip) 
 
if ($Res.Status -eq "Success") 
    { 

        $hostname = ([system.net.dns]::GetHostByAddress($ip)).hostname
  
        $result = "Success"  
        Write-Host "$result : Host $hostname reachable at " $ip
 
        $i++ 
 
    } 

else {
        $hostname = 'null'
        $result = "Failed" 
        Write-Host "$result to reach host $hostname at " + $ip
        $i++
    }
 
$output = new-object PSObject
$output | add-member NoteProperty IPAddress $ip
$output | add-member NoteProperty Hostname $hostname
$output | Add-Member NoteProperty Reachable $result

$output | export-csv "livehosts_$((Get-Date).ToString('MM-dd-yyyy_hh')).csv" -notypeinformation -append | select -skip $i
}  


Write-Host 'Scan Complete. Please check the livehosts.csv for results'
Pause 
}
}
Until ($classC -eq 'quit')
