@description('The Azure Region in which the Resources will be Deployed.')
param location string

@description('The Name of the App Service App.')
param appServiceAppName string

@description('The Name of the App Service Plan.')
param appServicePlanName string

@description('The Name of the App Service SKU.')
param appServicePlanSKUName string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSKUName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

@description('The Default Host Name of the App Service App.')
output appServiceAppHostName string = appServiceApp.properties.defaultHostName
