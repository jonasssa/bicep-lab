#* Install modules
scripts/helpers/Install-Modules.ps1 -Modules @{
    "Az.Resources" = "latest"
}

#* Get resourcegroups that are not part of the excluded tag nor groups containing the keep tag
$ResourceGroups = Get-AzResourceGroup
foreach($ResourceGroup in $ResourceGroups){
    $resources = Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName

    #* Removing all resources
    $resources | ForEach-Object -parallel {
        $ResourceName = $_.Name
        $ResourceType = $_.ResourceType
        $ResourceGroupName = $_.ResourceGroupName
        Write-Host "Removing resources in $ResourceGroupName" 

        Remove-AzResource -ResourceType $ResourceType -Name $ResourceName -ResourceGroupName $ResourceGroupName -Force -Confirm:$false
    }
}