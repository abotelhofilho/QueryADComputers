# QueryADComputers
Queries Active Directory for computer accounts depending on Windows OS of choice.
Test connectivity to computers and exports to a txt file.

This script was created from a need and constantly rewriting the same powershell script to look for computer accounts of a particular OS.
The connectivity testing is mostly useful for servers because servers are most likely ON all the time in comparison to workstations.

Prerequesite:<br>
Needs Active Directory tools installed on computer in order to load the Active Directory powershell module

Update:<br>
Fixed the NULL \ Empty DNSHostName field issue by replacing it with a combination of Get-ADDomain and the Name field in the Get-ADComputer to make the FQDN instead of depending on the DNSHostName field from Get-ADComputer

Shout out:<br>
Thanks to Pierre-Alexandre Braeken.  His PowerMemory script is what inspired making this script and making it as interactive as possible.
