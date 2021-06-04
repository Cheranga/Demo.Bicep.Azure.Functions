param buildNumber string
param location string = resourceGroup().location

@minLength(3)
@maxLength(24)
@description('The name of the storage account')
param sgName string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
])
param sku string = 'Standard_GRS'

param appInsName string
param planName string
param planSku string
param planTier string
param keyVaultName string
param funcAppName string

// Storage account
module storageAccountModule './StorageAccount/template.bicep' = {
  name: 'storageAccount-${buildNumber}'
  params: {
    sgName:sgName
    location:location
    sku:sku
  }
}

// Application insights
module appInsightsModule 'AppInsights/template.bicep' = {
  name:'appInsights-${buildNumber}'
  params:{
    name:appInsName
    rgLocation:location
  }
}

// App service plan
module aspModule 'AppServicePlan/template.bicep' = {
  name:'appServicePlan-${buildNumber}'
  params:{
    planName:planName
    planLocation:location
    planSku:planSku
    planTier:planTier
  }
}

// Key vault
module keyVaultModule 'KeyVault/template.bicep' = {
  name:'keyVault-${buildNumber}'
  params:{
    location:location
    keyVaultName:keyVaultName    
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

// Function app (without settings)
module functionAppModule 'FunctionApp/template.bicep' = {
  name: 'functionApp-${buildNumber}'
  params:{
    location:location
    functionAppName:funcAppName
    planName:aspModule.outputs.planId
  }
  dependsOn:[
    storageAccountModule
    aspModule
  ] 
}

// Function app settings
module functionAppSettingsModule 'FunctionAppSettings/template.bicep' = {
  name: 'functionAppSettings-${buildNumber}'
  params: {
    appInsightsKey: appInsightsModule.outputs.appInsightsKey
    dbConnectionStringSecretUri: keyVaultModule.outputs.dbConnectionStringUri
    functionAppName: functionAppModule.outputs.prodFunctionAppName
    functionAppStagingName: functionAppModule.outputs.stagingFunctionAppName
    storageAccountConnectionString: storageAccountModule.outputs.storageAccountConnectionString
  }  
  dependsOn:[
    functionAppModule
    appInsightsModule
    keyVaultModule
  ]
}

