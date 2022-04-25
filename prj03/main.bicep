@description('The Azure Region into which the resources should be displayed.')
param location string = resourceGroup().location

@description('The Name of the App Service Appp.')
param appServiceAppName string = 'toy-${uniqueString(resourceGroup().id)}'

@description('The Name of the App Service Plan SKU.')
param appServicePlanSKUName string = 'F1'

@description('Indicates Whether a CDN should be deployed.')
param deployCDN bool = true

var appServicePlanName = 'toy-product-launch-plan'

module app 'modules/app.bicep' = {
  name: 'toy-launch-app'
  params: {
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    appServicePlanSKUName: appServicePlanSKUName
    location: location
  }
}

module cdn 'modules/cdn.bicep' = if (deployCDN) {
  name: 'toy-launch-cdn'
  params: {
    orignalHostName: app.outputs.appServiceAppHostName
    httpsOnly: true
  }
}

@description('The Host Name to use to access the Website.')
output webSiteHostName string = deployCDN ? cdn.outputs.endpointHostName : app.outputs.appServiceAppHostName


