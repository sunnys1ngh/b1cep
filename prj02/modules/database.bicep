@description('The Azure Region Used for deployment.')
param location string

@secure()
@description('The SQL Server Administrator Password.')
param sqlAdministratorLogin string

@secure()
@description('The SQL Server Administrator Password.')
param sqlAdministratorPassword string

@description('The Name and Tier of the SQL DataBase SKU.')
param sqlDatabaseSKU object = {
  name: 'Standard'
  tier: 'Standard'
}

@description('The Name of the Environment. This is either Development OR Production')
@allowed([
  'Development'
  'Production'
])
param environmentName string = 'Development'

@description('Name of Audit Storage AC SKU')
param auditStorageACSKUName string = 'Standard_LRS'

var sqlServerName = 'teddy${location}${uniqueString(resourceGroup().id)}'
var sqlDatabaseName = 'TeddyBear'

var auditingEnabled = environmentName == 'Production'
var auditStorageACName = '${take('bearaudit${location}${uniqueString(resourceGroup().id)}', 24)}'

resource sqlServer 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: sqlDatabaseSKU
}

resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = if (auditingEnabled) {
  name: auditStorageACName
  location: location
  sku: {
    name: auditStorageACSKUName
  }
  kind: 'StorageV2'
}

resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2021-05-01-preview' = if (auditingEnabled) {
  parent: sqlServer
  name: 'default'
  properties: {
    state: 'Enabled'
    storageEndpoint: environmentName == 'Production' ? auditStorageAccount.properties.primaryEndpoints.blob : ''
    storageAccountAccessKey: environmentName == 'Production' ? listKeys(auditStorageAccount.id, auditStorageAccount.apiVersion).keys[0].value : ''
  }
}

output serverName string = sqlServer.name
output location string = location
output serverFullyQualifiedDomainName string = sqlServer.properties.fullyQualifiedDomainName

