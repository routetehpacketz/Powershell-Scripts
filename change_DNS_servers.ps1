$servers_list_file = Read-Host -prompt "Enter the path to the text file containing the list of target server names (ex. C:\users\Administrator\Documents\myservers.txt)"
$dns_servers = Read-Host -prompt "Enter a comma-separated list of the DNS server IP addresses you want to apply to your servers (ex. 10.1.1.10, 10.2.2.20)"
$servers = get-content $servers_list_file
foreach ($server in $servers){
	invoke-command $server -ScriptBlock{
		get-netadapter | Select -ExpandProperty Name | foreach {set-dnsclientserveraddress -InterfaceAlias $_ -ServerAddresses $using:dns_servers}
	}
}