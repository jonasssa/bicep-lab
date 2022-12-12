################### WARNING #########################
## This file is managed by workload-repo-template  ##
## Local changes will be overwritten               ##
#####################################################

[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $ServicePrincipalJson = $env:CREDENTIALS
)
$ProgressPreference = "SilentlyContinue"

## Install required modules
scripts/helpers/Install-Modules.ps1 -Modules @{
    "Az.Accounts" = "latest"
}

## Login
Write-Host "Start login with SPN"
$cred = $servicePrincipalJson | ConvertFrom-Json
$securePass = ConvertTo-SecureString -String $cred.clientSecret -AsPlainText -Force
$credential = [System.Management.Automation.PSCredential]::new('${cred.appId}', $securePass)
Connect-AzAccount -Credential $credential -ServicePrincipal -TenantId $cred.tenantId -Subscription $cred.subscriptionId -WarningAction Ignore | Out-Null
