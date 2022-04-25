@description('The Host Name (address) of the Orginal Server.')
param orignalHostName string

@description('The Name of the CDN Profile.')
param profileName string = 'cdn-${uniqueString(resourceGroup().id)}'

@description('The Name of the CDN Endpoint.')
param endPointName string = 'endPoint-${uniqueString(resourceGroup().id)}'

@description('Inidcates whether the CDN EndPoint requires HTTPS connections.')
param httpsOnly bool

var originName = 'my-origin'

resource cdnProfile 'Microsoft.Cdn/profiles@2020-09-01' = {
  name: profileName
  location: 'global'
  sku: {
    name: 'Standard_Microsoft'
  }
}

resource endPoint 'Microsoft.Cdn/profiles/endpoints@2020-09-01' = {
  parent: cdnProfile
  name: endPointName
  location: 'global'
  properties: {
    originHostHeader: orignalHostName
    isHttpAllowed: httpsOnly
    isHttpsAllowed: true
    queryStringCachingBehavior: 'IgnoreQueryString'
    contentTypesToCompress: [
      'text/plain'
      'text/html'
      'text/css'
      'application/x-javascript'
      'text/javascript'
    ]
    isCompressionEnabled: true
    origins: [
      {
        name: originName
        properties: {
          hostName: orignalHostName
        }
      }
    ]
  }
}

@description('The Host Name of the CDN Endpoint.')
output endpointHostName string = endPoint.properties.hostName
