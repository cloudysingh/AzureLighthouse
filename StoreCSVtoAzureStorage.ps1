<#
    .DESCRIPTION
        An example runbook which gets all the ARM resources using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Azure Automation Team
        LASTEDIT: Mar 14, 2016
#>
param(
    [parameter(Mandatory=$true)]
	[String] $CustomerSubscriptionID = "Enter the subscription ID of your customer's Azure Subscription",
    [parameter(Mandatory=$true)]
	[String] $StorageAccountResourceGroupName = "RG name where Storage Account resides",
    [parameter(Mandatory=$true)]
	[String] $StorageAccountName = "Name of the existing Storage Account where the CSV will be stored",
    [parameter(Mandatory=$true)]
	[String] $StorageAccountContainerName = "Name of the existing container where the CSV will be stored"
)
$connectionName = "AzureRunAsConnection"

try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Connect-AzAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 

}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

"Displaying all delegated Azure subscriptions"
Get-AzSubscription

"Setting the Context of Azure Subscription in this Session for Republicans..."
Set-AzContext -SubscriptionId $CustomerSubscriptionID

"Putting all the deallocated VMs in a CSV File"

#create a CSV in temp
$GetDate = Get-Date -Format "MM-dd-yyyy_HH_mm_ss"
$FileName = "DeallocatedVMList" + $GetDate + ".csv"
Get-AzVM -status | Where-Object {$_.PowerState -notlike "VM running"} | Export-Csv -Path $Home\$FileName -NoTypeInformation

$storageAccount = Get-AzStorageAccount -StorageAccountName $StorageAccountName -ResourceGroupName $StorageAccountResourceGroupName
$ctx = $storageAccount.Context


# upload a file
Set-AzStorageBlobContent -File $Home\$FileName `
  -Container $StorageAccountContainerName `
  -Blob $FileName `
  -Context $ctx 
"File Uploaded"
