# Author: routetehpacketz
# Github: https://github.com/routetehpacketz

# This one-liner will clear all of the "BAD_ADDRESS" entries in a single DHCP server's lease table
# Delete `-computer $your_DHCP_server` if you are running it directly on the target DHCP server
# Substitute `$your_DHCP_scope` with the target scope ID

get-dhcpserverv4lease -computer $your_DHCP_server -scopeid $your_DHCP_scope | Where-Object {$_.HostName -eq "BAD_ADDRESS"} | % {Remove-dhcpserverv4lease -computer $your_DHCP_server -IPAddress $_.IPAddress}
