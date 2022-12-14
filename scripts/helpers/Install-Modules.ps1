################### WARNING #########################
## This file is managed by workload-repo-template  ##
## Local changes will be overwritten               ##
#####################################################

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [hashtable]
    $Modules
)

## Defaults
$ProgressPreference = "SilentlyContinue"

## Print PSVersion
Write-Host "PSVersion: $($PSVersionTable.PSVersion)"

## Allow modules from PSGallery repository
$psRepo = Get-PSRepository -Name "PSGallery"
if ($psRepo.InstallationPolicy -ne "Trusted") {
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

## Install modules
foreach ($name in $modules.Keys) {
    $version = $modules[$name]
    $existingModules = @(Get-Module -ListAvailable -Name $name)

    if ($version -eq "latest") {
        if (!$existingModules -or $existingModules.Count -eq 0) {
            Write-Host "Installing $name@$version module"
            Install-Module -Name $name -AllowClobber | Out-Null
        }
        else {
            Write-Host "$name@$version module already exists"
        }
    }
    else {
        $existingModule = $existingModules | Where-Object { $_.Version -eq $version }
        if (!$existingModule) {
            Write-Host "Installing $name@$version module"
            Install-Module -Name $name -AllowClobber -RequiredVersion $version | Out-Null
        }
        else {
            Write-Host "$name module already exists"
        }
    }
}