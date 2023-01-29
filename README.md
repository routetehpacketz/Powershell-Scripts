# Powershell-Scripts
This is a generic repository of Powershell scripts that some may find useful. Most will require RSAT.

#### change_DNS_servers.ps1
------

Compatibility: Windows Server 2012 R2 or higher

Prompts for a text file containing a list of target computer names and prompts for a list of DNS server IPs to set on the target computers:
```
Enter the path to the text file containing the list of target server names (ex. C:\users\Administrator\Documents\myservers.txt): C:\myservers.txt
Enter a comma-separated list of the DNS server IP addresses you want to apply to your servers (ex. 10.1.1.10, 10.2.2.20): 10.1.1.10, 10.2.2.20
```
Note: This script will change the DNS server IPs on __all__ network adapters *with static IP configuration*. Adapters set to obtain IP info automatically will not be changed.

#### dns_find_missing_ptr_records.ps1

This script queries for all static AD DNS A records in a specified forward lookup zone and checks to see if there is a corresponding PTR record in the respective reverse DNS zone. It will then provide the option to output the results to a CSV file in the running user's Documnets folder. It currently runs on console prompts, but I plan to change it to use input parameters.

Note: This script currently expects your reverse DNS zones to be based on the second octect of the discovered A records. Enhancing this is another to-do for this script.

```
Enter DNS server name: ad-dns-server-name.contoso.com
Enter the name of your forward lookup zone: contoso.com
You have 50 missing PTR records.
Would you like to output these results to a CSV file?
Please answer [y]es or [n]o: y
```
