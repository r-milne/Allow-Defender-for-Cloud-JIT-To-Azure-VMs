# Allow-Defender-for-Cloud-JIT-To-Azure-VMs
Allows connections via Defender for Cloud JIT To Azure VMs.

Note that JIT is assumed to have been previously enabled on the given VMs.  This script to to allow the connection(s) via the previously defined policy.


Note that PowerShell 7 is needed for the -AsUTC paramater of Get-Date or use Azure Cloud shell which is the intended purpose of the script 
Script assumes that you are already connected to Azure and the correct subscription
Add in the Connect-Azaccount if needed
Also optionally add in the relevant subscription etc 
Connect-AzAccount -Subscription "459d9dbf-b57b-55c4-96ef-f21070b9eaab"

If running using Azure Cloud Shell, specify the IP.  
The API call below will detect the public IP of the Azure resource, not where you are actually wanting to RDP from
$MyIPAddress = @("131.107.2.200")

If you run this locally, an option is to query and API to get your public IP
#$MyIPAddress = Invoke-RestMethod ipinfo.io/ip
