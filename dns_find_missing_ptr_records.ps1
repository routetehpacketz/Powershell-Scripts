$dns_server = Read-Host -Prompt "Enter DNS server name"
$fwd_zone = Read-Host -Prompt "Enter the name of your forward lookup zone"

# Get all of the A records in the target zone
$forward_dns_rrs = get-dnsserverresourcerecord -computername $dns_server -ZoneName "$fwd_zone" -RRType 'A' | Where-Object {$_.TimeStamp -lt 1}

# Get all of the reverse DNS zones
$reverse_dns_zones = Get-DnsServerZone -ComputerName $dns_server | Where-Object {$_.IsReverseLookupZone -eq $true}

$missing_ptrs = New-Object System.Collections.Generic.List[System.String]
$missing_ptrs.Add('HostName,IPAddress,ReverseDNSZone')

# Iterate over A records for $fwd_zone
foreach ($rr in $forward_dns_rrs){
	
	# Split the octets of the A record's IP address and store in list
	$rr_ip = @($rr.RecordData.IPv4Address.IPAddressToString -split '\.')
	
	# Lookup reverse zone based on reverse of IP's first two octets
	$reverse_zone_name = $rr_ip[1] + '.' + $rr_ip[0] + '.in-addr.arpa'
	
	# Reverse last two octets for PTR lookup
	$rr_ptr = $rr_ip[3] + '.' + $rr_ip[2]
	
	$reverse_zone = Get-DnsServerZone -ComputerName $dns_server -ZoneName $reverse_zone_name -ErrorAction SilentlyContinue
	if (-not $reverse_zone){
		$reverse_zone = 'zone_not_found'
		$missing_ptrs.Add("$($rr.Hostname),$($rr.RecordData.IPv4Address.IPAddressToString),$reverse_zone")
		Continue
	}
		
	$ptr_record = Get-DnsServerResourceRecord -ComputerName $dns_server -RRType 'PTR' -ZoneName $reverse_zone.ZoneName -Name $rr_ptr -ErrorAction SilentlyContinue
	if (-not $ptr_record){
		$missing_ptrs.Add("$($rr.Hostname),$($rr.RecordData.IPv4Address.IPAddressToString),$reverse_zone_name")
	}
}

# Check if no missing PTR records were found
if ($missing_ptrs.Count -lt 2){
	Write-Host "No missing PTR records found"
	Exit
} else{
	Write-Host "You have $($missing_ptrs.Count) missing PTR records."
	Write-Host "Would you like to output these results to a CSV file?"
	$output_results = Read-Host -Prompt "Please answer [yes] or [n]o"
	while (@('yes','y','no','n') -NotContains $output_results){
		$output_results = Read-Host -Prompt "Please answer [yes] or [n]o"
	}
	if ($output_results -eq 'yes' -or $output_results -eq 'y'){
		$missing_ptrs | Out-File -Append "$env:userprofile\Documents\dns_missing_ptrs_$(Get-Date -Format 'yyyy-MM-dd-HH-mm').csv"
	} else {
		Write-Host "Report declined."
	}
}
