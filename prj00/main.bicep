param location string = resourceGroup().location
param storageACName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param appServiceAPPName string = 'toylaunch${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSKUName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageACName
  location: location
  sku:{
    name: storageAccountSKUName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAPPName: appServiceAPPName
    environmentType: environmentType
  }
}

output appServiceAPPHostName string = appService.outputs.appServiceAPPHostName
