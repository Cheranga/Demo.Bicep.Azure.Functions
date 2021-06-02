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
    productionPrincipalId:functionAppModule.outputs.productionPrincipalId
    productionTenantId:functionAppModule.outputs.productionTenantId
    stagingPrincipalId:functionAppModule.outputs.stagingPrincipalId
    stagingTenantId:functionAppModule.outputs.stagingTenantId         
  }
  dependsOn:[
    functionAppModule
  ]
}

module functionAppModule 'FunctionApp/template.bicep' = {
  name: 'functionApp'
  params:{
    location:location
    rgName:resourceGroup().name
    functionAppName:funcAppName
    planName:aspModule.outputs.planId
  }
  dependsOn:[
    storageAccountModule
    aspModule
  ] 
}

module functionAppSettingsModule 'FunctionAppSettings/template.bicep' = {
  name: 'functionAppSettings'
  params: {
    appInsightsKey: appInsightsModule.outputs.appInsightsKey
    dbConnectionStringSecretUri: keyVaultModule.outputs.dbConnectionStringUri
    functionAppName: funcAppName
    storageAccountConnectionString: storageAccountModule.outputs.storageAccountConnectionString
  }  
  dependsOn:[
    functionAppModule
    appInsightsModule
    keyVaultModule
  ]
}

