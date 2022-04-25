<#
You needed to deploy the same resources in multiple locations and a variety of environments. 
You wanted to create flexible Bicep templates that you can reuse, and to control resource 
deployments by changing the deployment parameters. To deploy some resources only to certain 
environments, you added conditions to your template. You then used copy loops to deploy resources
into various Azure regions. You used variable loops to define the properties of the resources to 
be deployed. Finally, you used output loops to retrieve the properties of those deployed resources.
Without the conditions and copy loops features, you would have to maintain and use multiple versions
of Bicep templates. You would have to apply every change in your environment in multiple templates.
Maintaining all these templates would entail a great deal of effort and overhead. By using conditions
and loops, you were able to create a single template that works for all your regions and environments
and ensure that all your resources are configured identically.
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
Set-Location -Path "C:\Users\ss\OneDrive\-----new_repos\repo\bicepcode\prj02"
New-AzResourceGroupDeployment -TemplateFile main.bicep -Verbose # if you add -environmentName 'Production' it will also build resources for auditing
Get-AzResourceGroupDeployment -ResourceGroupName $rgname -Verbose

#To Remove Resource Group
Remove-AzResourceGroup -Name $rgname -Force -Verbose
