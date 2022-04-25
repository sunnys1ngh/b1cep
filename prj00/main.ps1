Connect-AzAccount

Get-AzSubscription

$context = Get-AzSubscription -SubscriptionName 'Concierge Subscription'
Set-AzContext $context


# May not be required - Only if it lists more than one Concierge Subscription
# Then Get-AzSubscription & copy the ID as below example
$context = Get-AzSubscription -SubscriptionId d47c5709-1880-4278-a75a-0e0f6343170f
Set-AzContext $context

New-AzResourceGroup -Name bicepex001 -Location 'uksouth' -Verbose
Set-AzDefault -ResourceGroupName bicepex001

New-AzResourceGroupDeployment -TemplateFile .\main.bicep

Get-AzResourceGroupDeployment -ResourceGroupName bicepex001 | Format-Table

New-AzResourceGroupDeployment `
  -TemplateFile main.bicep `
  -environmentType nonprod