param rgName string = 'tbd'
param location string = 'tbd'
param functionAppName string = 'tbd'
param planName string = 'tbd'
param keyVaultName string = 'tbd'

@secure()
param storageAccountConnectionString string = 'tbd'

@secure()
param appInsightsKey string = 'tbd'


var timeZone = 'AUS Eastern Standard Time'

resource functionAppName_resource 'Microsoft.Web/sites@2020-12-01' = {
  name: functionAppName
  identity:{
    type:'SystemAssigned'    
  }
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: planName
  }
}

resource functionAppName_slotConfigNames 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${functionAppName_resource.name}/slotConfigNames'  
  properties: {
    appSettingNames: [
      'CustomerApiKey'
    ]
  }
  dependsOn:[
    functionAppName_resource
  ]
}

resource functionAppName_appsettings 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${functionAppName_resource.name}/appsettings'
  properties: {
    AzureWebJobsStorage: storageAccountConnectionString
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: storageAccountConnectionString
    WEBSITE_CONTENTSHARE: toLower(functionAppName)
    FUNCTIONS_EXTENSION_VERSION: '~3'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsKey
    FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    WEBSITE_TIME_ZONE: timeZone
    WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG: 1
  }
}

resource functionAppName_Staging 'Microsoft.Web/sites/slots@2016-08-01' = {
  name: '${functionAppName_resource.name}/Staging'
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: planName
  }
}

resource functionAppName_Staging_appsettings 'Microsoft.Web/sites/slots/config@2016-08-01' = {
  name: '${functionAppName_Staging.name}/appsettings'
  properties: {
    AzureWebJobsStorage: storageAccountConnectionString
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: storageAccountConnectionString
    WEBSITE_CONTENTSHARE: toLower(functionAppName)
    FUNCTIONS_EXTENSION_VERSION: '~3'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsKey
    FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    WEBSITE_TIME_ZONE: timeZone
    WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG: 1
  }
}

output masterKey string = listkeys('${resourceId(rgName, 'Microsoft.Web/sites', functionAppName)}/host/default', '2018-11-01').masterKey
