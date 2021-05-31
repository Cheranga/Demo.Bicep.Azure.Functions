param location string = resourceGroup().location

@minLength(3)
@maxLength(11)
@description('The name of the storage account')
param sgName string = 'tbd'

@allowed([
  'Standard_LRS'
  'Standard_GRS'
])
param sku string = 'Standard_GRS'

param appInsName string = 'tbd'

module storageAccountModule './StorageAccount/template.bicep' = {
  name: 'storageAccount'
  params: {
    sgName:sgName
    location:location
    sku:sku
  }
}

output storageEndpoint string = storageAccountModule.outputs.storageAccountConnectionString

module appInsightsModule 'AppInsights/template.bicep' = {
  name:'appInsights'
  params:{
    name:appInsName
    rgLocation:location
  }
}

output appInsightsKey string = appInsightsModule.outputs.appInsightsKey

