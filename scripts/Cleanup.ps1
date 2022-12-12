param (
    [Parameter()]
    [boolean]
    $RemoveLocks = $true,

    [Parameter()]
    [string[]]
    $excludedResourceGroupNames = @(
        'AzureBackupRG_westeurope_1'
        'AzureBackupRG_westeurope_2'
        'AzureBackupRG_westeurope_3'
        'AzureBackupRG_westeurope_4'
        'AzureBackupRG_westeurope_5'
        'lz'
        'lz-network'
        'NetworkWatcherRG'
    )
)
#* Install modules
scripts/helpers/Install-Modules.ps1 -Modules @{
    "Az.Resources" = "latest"
}

#* Get resourcegroups that are not part of the excluded tag nor groups containing the keep tag
$resources = Get-AzResource -ResourceGroupName "jonas-test-rg"

#* Removing all resources
$resources | ForEach-Object -parallel {
    $ResourceName = $_.Name
    $ResourceType = $_.ResourceType
    Write-Host "Removing resources in $ResourceName" 

    Remove-AzResource -ResourceType $ResourceType -Name $ResourceName -ResourceGroupName "jonas-test-rg" -Force -Confirm:$false
}