Get-AzSubscription -Verbose

#Create Random ResourceGroupName
$location = 'westeurope'
$topic = "rg-prj-bicep-"
$random = Get-Random -Minimum 1000000 -Maximum 9999999 -Verbose
$rgname = $topic+$random
New-AzResourceGroup -Name $rgname -Location $location -Force -Verbose
Set-AzDefault -ResourceGroupName $rgname -Verbose

#Deploy Bicep Template
Set-Location -Path "C:\Users\ss\OneDrive\-----new_repos\repo\bicepcode\prj04"
New-AzResourceGroupDeployment -TemplateFile main.bicep -Verbose # if you add -environmentName 'Production' it will also build resources for auditing
Get-AzResourceGroupDeployment -ResourceGroupName $rgname -Verbose

#To Remove Resource Group
Remove-AzResourceGroup -Name $rgname -Force -Verbose

New-AzOperationalInsightsWorkspace `
  -Name ToyLogs `
  -Location westeurope

  New-AzStorageAccount `
  -Name sstoyss1n9h `
  -Location westeurope `
  -SkuName Standard_LRS

New-AzResourceGroupDeployment `
  -TemplateFile main.bicep `
  -storageAccountName sstoyss1n9h