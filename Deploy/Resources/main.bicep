param location string = resourceGroup().location

@minLength(3)
@maxLength(24)
@description('The name of the storage account')
param sgName string = 'tbd'

@allowed([
  'Standard_LRS'
  'Standard_GRS'
])
param sku string = 'Standard_GRS'

param appInsName string = 'tbd'

param planName string = 'tbd'
param planSku string = 'tbd'
param planTier string = 'tbd'
param keyVaultName string = 'tbd'
param funcAppName string = 'tbd'

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

module aspModule 'AppServicePlan/template.bicep' = {
  name:'appServicePlan'
  params:{
    planName:planName
    planLocation:location
    planSku:planSku
    planTier:planTier
  }
}

module keyVaultModule 'KeyVault/template.bicep' = {
  name:'keyVault'
  params:{
    location:location
    keyVaultName:keyVaultName
    functionAppName:funcAppName
    storageConnectionString:storageAccountModule.outputs.storageAccountConnectionString    
  }
  dependsOn:[
    functionAppModule
  ]
}

module functionAppModule 'FunctionApp/template.bicep' = {
  name: 'functionApp'
  params:{
    functionAppName:funcAppName
    location:location
    planName:planName
    keyVaultName:keyVaultName
    rgName:resourceGroup().name
    storageAccountConnectionString:storageAccountModule.outputs.storageAccountConnectionString
    appInsightsKey:appInsightsModule.outputs.appInsightsKey    
  }
  dependsOn:[
    storageAccountModule
    aspModule
    appInsightsModule
  ] 
}

