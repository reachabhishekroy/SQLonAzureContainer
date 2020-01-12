<#
.SYNOPSIS
  This script can validate or deploy any ARM templates to Azure.

.DESCRIPTION
  This script can validate or deploy any ARM templates to Azure. 

.NOTES
  Version:        1.0
  Author:         Abhishek Roy
  Creation Date:  12.01.2020
#>

[CmdletBinding()]
param
(
    [Parameter(Mandatory=$true)]
    [System.String]$TemplateFile,

    [Parameter(Mandatory=$true)]
    [System.String]$ParametersFile,

    [Parameter(Mandatory=$true)]
    [System.String]$ResourceGroupParametersFile,

    [Parameter(Mandatory=$true)]
    [System.String]$DeploymentName
    
)

$objResourceGroupParametersFile = Get-Content -Path $ResourceGroupParametersFile | ConvertFrom-Json
[System.String] $ResourceGroupName = $objResourceGroupParametersFile.parameters.rgName[0].value
[System.String] $ResourceGroupLocation = $objResourceGroupParametersFile.parameters.rgLocation[0].value


New-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Force

New-AzResourceGroupDeployment `
      -ResourceGroupName $ResourceGroupName `
      -Name $DeploymentName `
      -TemplateParameterFile $ParametersFile `
      -TemplateFile $TemplateFile `
      -Mode Incremental -Force
