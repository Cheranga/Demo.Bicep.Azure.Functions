param functionAppName string
param functionAppStagingName string
param storageAccountConnectionString string
param appInsightsKey string
param timeZone string = 'AUS Eastern Standard Time'
param dbConnectionStringSecretUri string

var dbConnectionString = '@Microsoft.KeyVault(SecretUri=${dbConnectionStringSecretUri}/)'

resource functionAppSlotConfigNames 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${functionAppName}/slotConfigNames'  
  properties: {
    appSettingNames: [
      'CustomerApiKey'
    ]
  }
}

resource functionAppAppsettings 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${functionAppName}/appsettings'
  properties: {
    CustomerApiKey: 'This is the production setting'
    databaseConnectionString: dbConnectionString
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

resource functionAppStagingAppsettings 'Microsoft.Web/sites/slots/config@2016-08-01' = {
  name: '${functionAppStagingName}/appsettings'
  properties: {
    CustomerApiKey: 'This is the staging setting'
    databaseConnectionString: dbConnectionString
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
