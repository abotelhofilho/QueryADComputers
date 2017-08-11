# Author: Antonino D. BotelhoFilho
# Created On: 10/10/2016
# Rev:3.0
# 1.0 First Draft
# 2.0 OutputFile Prompt
# 3.0 Work in Progress - OS choise Prompt
# 3.1 Fixed the DNSHostName NULL\Empty value issue
#
#= = = = = = = = = = = = = =_S_H_O_U_T__O_U_T_= = = = = = = = = = = = = = = =#
# Shout out \ Credit to Pierre-Alexandre Braeken for his PowerMemory script  #
# function Stop-Script was borrowed from Pierre-Alexandre Braeken            #
# The command switch () I discovered from Pierre-Alexandre Braeken           #
###############################################################################

## NULL Variables #############################################################
$rtn = $null
$Server = $null
$OutputFile = $null
$OSQuery = $null
$QueryType = $null
$Testpath = $null
$OutputFileTest = $null
$Exit = $null
$CheckFile = $null
$FileOverWrite = $null
$ADDomain = $null
$FQDN = $null

## Functions #################################################################

function Stop-Script () {
    "Script terminating..."
    Write-Output "============================================================"
    Exit
}

###############################################################################

## Import Active Directory(AD) Powershell Module
Import-Module activedirectory

## Print and Prompt for Operating System
Write-Host "`nWorkstation Operating Systems?"
Write-Host "`tEnter 1 for Windows XP?" -ForegroundColor Red
Write-Host "`tEnter 2 for Windows Vista?" -ForegroundColor Red
Write-Host "`tEnter 3 for Windows 7?" -ForegroundColor Yellow
Write-Host "`tEnter 4 for Windows 8 and 8.1?" -ForegroundColor Yellow
Write-Host "`tEnter 5 for Windows 10?" -ForegroundColor Green
Write-Host "`nServer Operating Systems?"
Write-Host "`tEnter 6 for Windows Server 2000?" -ForegroundColor Red
Write-Host "`tEnter 7 for Windows Server 2003?" -ForegroundColor Red
Write-Host "`tEnter 8 for Windows Server 2008 and 2008 R2?" -ForegroundColor Yellow
Write-Host "`tEnter 9 for Windows Server 2012 and 2012 R2?" -ForegroundColor Green
Write-Host "`tEnter 10 for Windows Server 2016?" -ForegroundColor Green
Write-Host "`nEnter 0 to Exit"
$QueryType = Read-Host "`nWhat Operating System do you want to look for?"

switch ($QueryType){
    "1" {$QueryType = 1}
    "2" {$QueryType = 2}
    "3" {$QueryType = 3}
    "4" {$QueryType = 4}
    "5" {$QueryType = 5}
    "6" {$QueryType = 6}
    "7" {$QueryType = 7}
    "8" {$QueryType = 8}
    "9" {$QueryType = 9}
    "10" {$QueryType = 10}
    "0" {Stop-Script}
        default {Write-Output "This option is invalid... Exiting...";Stop-Script}
}

IF ($QueryType -eq 1) {$OSQuery = "*XP*"}
IF ($QueryType -eq 2) {$OSQuery = "*Vista*"}
IF ($QueryType -eq 3) {$OSQuery = "*7*"}
IF ($QueryType -eq 4) {$OSQuery = "*8*"}
IF ($QueryType -eq 5) {$OSQuery = "*10*"}
IF ($QueryType -eq 6) {$OSQuery = "*2000*"}
IF ($QueryType -eq 7) {$OSQuery = "*2003*"}
IF ($QueryType -eq 8) {$OSQuery = "*2008*"}
IF ($QueryType -eq 9) {$OSQuery = "*2012*"}
IF ($QueryType -eq 10) {$OSQuery = "*2016*"}

## Prompt for Out-File path, validate file path
DO {
  $OutputFile = Read-Host -Prompt "`nPlease enter UNC path for output file"; $Testpath = Test-path $OutputFile
IF ($Testpath -match 'True'){$OutputFileTest = "True"}
  ELSE{
  Write-Host "`nThe file path entered doesn't exist or is invalid." -ForegroundColor Red}
}
UNTIL ($OutputFileTest -eq "True")

## Check if output File already exists and prompt for removal of old file
$CheckFile = Test-path $OutputFile\QueryADComputers.txt
IF ($CheckFile -match 'True') {
  Write-Host "`n`t`t!!! WARNING!!!`nA QueryADComputers.txt file already exists.
If you continue, the old file will be deleted."  -ForegroundColor Yellow;
$FileOverWrite = Read-Host "`nWould you like to continue? (Y\N)"

switch ($FileOverWrite){
      "Y" {$FileOverWrite = "Y"}
      "N" {Stop-Script}
           default {Write-Output "This option is invalid... Exiting...";Stop-Script}
}

IF ($FileOverWrite -eq "Y") {Remove-Item $OutputFile\QueryADComputers.txt}

}

$ADDomain = Get-ADDomain

## Query AD for all computer accounts which have a matching the desired Operating System
$Server = Get-ADComputer -f * -pr *| where {$_.OperatingSystem -like $OSQuery} | Select Name

## Loop through each value in the $Server variable and test if connection is successfull.
## The -Quiet switch makes it a True\False statement
ForEach ($Name in $Server) {$FQDN = $Name.Name + '.' + $ADDomain.Forest ;
  $rtn = Test-Connection -CN $FQDN -Count 1 -BufferSize 16 -Quiet

## If the test connection is a success write\append to a file
IF ($rtn -match 'True') {
  Write-Output $FQDN | Out-File -Append $OutputFile\QueryADComputers.txt}
}

## Exit with style lol
$Exit = Write-Output "-=-=-=-=-=-=-=-="
$Exit = $Exit * 8
Write-Host "Script Complete `nExiting" $Exit -ForegroundColor Magenta ; Start-Sleep -s 10 ; Exit
