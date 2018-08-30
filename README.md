# Powershell-Scripts
This is a master repository for Powershell scripts that may be useful more than one time.

#### change_DNS_servers.ps1
------

Compatibility: Windows Server 2012 R2 or higher

Prompts for a text file containing a list of target computer names and prompts for a list of DNS server IPs to set on the target computers:
```
Enter the path to the text file containing the list of target server names (ex. C:\users\Administrator\Documents\myservers.txt): C:\myservers.txt
Enter a comma-separated list of the DNS server IP addresses you want to apply to your servers (ex. 10.1.1.10, 10.2.2.20): 10.1.1.10, 10.2.2.20
```
Note: This script will change the DNS server IPs on __all network adapters__.
