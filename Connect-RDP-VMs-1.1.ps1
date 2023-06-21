<# 

.SYNOPSIS
Simple method to allow Just Enough Access Just In Time to Azure VMs that are managed by Microsoft Defender for Cloud (MDC).  
Having to use the portal to allow RDP connections is painful and has issues. 

.DESCRIPTION
Please also see the associated blog post:

https://blog.rmilne.ca/2023/06/21/quick-tip-easily-allow-jit-to-azure-vms-in-a-resource-group/

Note that PowerShell 7 is needed for the -AsUTC paramater of Get-Date or use Azure Cloud shell which is the intended purpose of the script 
Script assumes that you are already connected to Azure and the correct subscription
Add in the Connect-Azaccount if needed
Also optionally add in the relevant subscription etc 
Connect-AzAccount -Subscription "459d9dbf-b57b-55c4-96ef-f21070b9eaab"


.VERSION
	1.0 1-5-2023	-- Initial Version
	1.1 21-6-2023 	-- Released to GitHub 

.DISCLAIMER
This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that You agree: (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code. Please note: None of the conditions outlined in the disclaimer above will supercede the terms and conditions contained within the Premier Customer Services Description. This posting is provided "AS IS" with no warranties, and confers no rights.

Use of included script samples are subject to the terms specified at http://www.microsoft.com/info/cpyright.htm.



#>


# If running using Azure Cloud Shell, specify the IP.  The API call below will detect the public IP of the Azure resource, not where you are actually wanting to RDP from
$MyIPAddress = @("131.107.2.200")
# If you run this locally, an option is to query and API to get your public IP
#$MyIPAddress = Invoke-RestMethod ipinfo.io/ip

# Get a collection of the VMs we want to connect to
$VMs = Get-AzVM -ResourceGroupName "Wingtiptoys-Canada"

# Get current time and add 4 hours
$EndTime = Get-Date (Get-Date -AsUTC).AddHours(1) -Format O


ForEach  ($VM in $VMs)
{

$Resource = Get-AzResource -ResourceId $vm.id

# Define the policy
$JitPolicy = (@{
    id=$Resource.ResourceID;
    ports=(@{
       number=3389;
       endTimeUtc=$EndTime;
       allowedSourceAddressPrefix=$MyIPAddress})})


# Save the policy in an array 
$ArrJitPolicy=@($JitPolicy)


# Request access
$Resource.ResourceID
Start-AzJitNetworkAccessPolicy -ResourceGroupName $VM.ResourceGroupName -Name "Default" -Location $Resource.Location -VirtualMachine $ArrJitPolicy

}
