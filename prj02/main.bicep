@description('The Azure regions into which the resources should be deployed.')
param locations array = [
  'westeurope'
  'uksouth'
  'northeurope'
]

@secure()
@description('The administrator login username for the SQL server.')
param sqlAdministratorLogin string

@description('The IP Address Range for Virtual Networks for Deployment.')
param virtualNetworkAddressPrefix string = '10.10.0.0/16'

@description('The Name & IP Adress Range for each Subnet in the Virtual Networks.')
param subnets array = [
  {
    name: 'frontEnd'
    ipAddressRange: '10.10.5.0/24'
  }
  {
    name: 'backEnd'
    ipAddressRange: '10.10.10.0/24'
  }
]

var subnetProperties = [for subnet in subnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]

resource virtualNetworks 'Microsoft.Network/virtualNetworks@2021-03-01' = [for location in locations: {
  name: 'teddybear-${location}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
    subnets: subnetProperties
  }
}]

@secure()
@description('The administrator login password for the SQL server.')
param sqlAdministratorPassword string

module databases 'modules/database.bicep' = [for location in locations: {
  name: 'database-${location}'
  params: {
    location: location
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorPassword: sqlAdministratorPassword
  }
}]

output serverInfo array = [for i in range(0, length(locations)): {
  name: databases[i].outputs.serverName
  location: databases[i].outputs.location
  fullyQualifiedDomainName: databases[i].outputs.serverFullyQualifiedDomainName
}]
