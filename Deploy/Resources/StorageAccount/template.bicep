param sgName string
param location string = resourceGroup().location
param sku string

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: sgName
  location: location
  kind: 'StorageV2'
  sku:{
    name:sku
    tier:'Standard'
  }
}



output storageAccountConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${sgName};AccountKey=${listKeys(resourceId(resourceGroup().name, 'Microsoft.Storage/storageAccounts', sgName), '2019-04-01').keys[0].value};EndpointSuffix=core.windows.net'
