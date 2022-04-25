<#
adding a content delivery network, or CDN, to your company's website for the launch of a toy wombat.
However, other teams in your company have told you they don't need a CDN. 
In this exercise, you'll create modules for the website and the CDN, and you'll add the modules to a template.
#>


Get-AzSubscription -Verbose

#Create Random ResourceGroupName
$location = 'uksouth'
$topic = "rg-prj-bicep-"
$random = Get-Random -Minimum 1000000 -Maximum 9999999 -Verbose
$rgname = $topic+$random
New-AzResourceGroup -Name $rgname -Location $location -Force -Verbose
Set-AzDefault -ResourceGroupName $rgname -Verbose

#Deploy Bicep Template
Set-Location -Path "C:\Users\ss\OneDrive\-----new_repos\repo\bicepcode\prj03"
New-AzResourceGroupDeployment -TemplateFile main.bicep -Verbose # if you add -environmentName 'Production' it will also build resources for auditing
Get-AzResourceGroupDeployment -ResourceGroupName $rgname -Verbose

#To Remove Resource Group
Remove-AzResourceGroup -Name $rgname -Force -Verbose
