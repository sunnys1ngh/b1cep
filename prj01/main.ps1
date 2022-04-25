##################################################################################################################################
Connect-AzAccount
Get-AzSubscription -Verbose

#Create  A Random ResourceGroupName & Set As Default
$keyvname = 'toykey'
$location = 'uksouth'
$topic = "prj-bicep-"
$random = Get-Random -Minimum 1000000 -Maximum 9999999 -Verbose
$rgname = $topic+$random
New-AzResourceGroup -Name $rgname -Location $location -Force -Verbose
Set-AzDefault -ResourceGroupName $rgname -Verbose

#Build A KeyVault
$keyVaultName = $keyvname+$rgname # A unique name for the key vault.
$login = 'admin123' # The login that you used in the previous step.
$password = 'Letme!n123' # The password that you used in the previous step.

$sqlServerAdministratorLogin = ConvertTo-SecureString $login -AsPlainText -Force -Verbose
$sqlServerAdministratorPassword = ConvertTo-SecureString $password -AsPlainText -Force -Verbose

New-AzKeyVault -VaultName $keyVaultName -Location $location -EnabledForTemplateDeployment -Verbose
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorLogin' -SecretValue $sqlServerAdministratorLogin -Verbose
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorPassword' -SecretValue $sqlServerAdministratorPassword -Verbose

#Add Value To Paramters File
$keyid = (Get-AzKeyVault -Name $keyVaultName).ResourceId
$data = Get-Content -Path "C:\Users\ss\OneDrive\-----new_repos\repo\bicepcode\prj01\main.parameters.dev.json" -raw | ConvertFrom-Json
#$Row=2 
#$col=2 
$data.parameters.sqlServerAdministratorLogin.reference.keyVault.id = $keyid
$data.parameters.sqlServerAdministratorPassword.reference.keyVault.id = $keyid
$data | ConvertTo-Json -Depth 9 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) } | set-content -Path "C:\Users\ss\OneDrive\-----new_repos\repo\bicepcode\prj01\newParam.dev.json" -Force -Verbose

#Deploy Bicep Template
Set-Location -Path "C:\Users\ss\OneDrive\-----new_repos\repo\bicepcode\prj01" -Verbose
New-AzResourceGroupDeployment `
  -TemplateFile main.bicep `
  -TemplateParameterFile newParam.dev.json `
  -Verbose

Get-AzResourceGroupDeployment -ResourceGroupName $rgname | ConvertTo-Csv -Verbose 

#To Remove Resource Group & Parameter File
$path = "C:\Users\ss\OneDrive\-----new_repos\repo\bicepcode\prj01\newParam.dev.json"
Remove-AzResourceGroup -Name $rgname -Force -Verbose
Remove-Item -Path $path -Force -Verbose
#####################################################################################################################################

