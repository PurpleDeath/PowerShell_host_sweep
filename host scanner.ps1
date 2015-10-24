# $iprange = Read-Host 'Enter the class C address of the range you wish to scan'
# 
# 1..20 | % {"$iprange.$($_): $(Test-Connection -count 1 -comp 192.168.1.$($_) )"}

$Subnet = Read-Host 'Please enter the first three octets of the range you wish to scan'
$MinAddress = Read-host 'Please enter the first IP of the last octet you wish to scan'
$MaxAddress = Read-host 'Please enter the last IP of the last octet you wish to scan'
# step through each address from MinAddress to MaxAddress
for($Address=$MinAddress;$Address -le $MaxAddress;$Address++){
    # make a text string for the current IP address to be tested
    $TestAddress = $Subnet+"."+[convert]::ToString($Address)
    # do the ping(s), don't display red text if the ping fails (erroraction)
    $Result = Test-Connection -ComputerName $TestAddress -Count 1 -ErrorAction SilentlyContinue
    if($Result -eq $null){
        Write-Host "No reply from $TestAddress" -NoNewline
        # have to use try/catch as the GetHostByAddress errors in a nasty way if it doesn't find anything
        try{
            # do the reverse DNS query
            $HostName = [System.Net.Dns]::GetHostByAddress($TestAddress).HostName
            if($HostName -ne $null){
                # found something in DNS, display it
                Write-Host " ($HostName)"
            }
        } catch {
            # didn't find anything (GetHostByAddress generated an error), just do a CRLF
            write-host ""
        }
    }
}

$subnet = Read-Host 'please enter the first three octets of the range you wish to scan'
$st = Read-Host 'enter the first digit of the last octet'
$end = Read-Host 'enter the last digit of the last octet'

$range = $st..$end
$address = $subnet.($range)

return $address