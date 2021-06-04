param sgName string
param location string = resourceGroup().location
param sku string
param kind string = 'StorageV2'
param tier string = 'Standard'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: sgName
  location: location
  kind: kind
  sku:{
    name:sku
    tier:tier
  }
}

output storageAccountConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${sgName};AccountKey=${listKeys(resourceId(resourceGroup().name, 'Microsoft.Storage/storageAccounts', sgName), '2019-04-01').keys[0].value};EndpointSuffix=core.windows.net'
