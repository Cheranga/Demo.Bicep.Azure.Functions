param functionAppName string
param location string
param planId string
param appInsightsKey string
param storageConnectionString string


resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    httpsOnly: true
    serverFarmId: planId
    clientAffinityEnabled: true
    siteConfig: {
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': appInsightsKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: storageConnectionString
        }
        {
          'name': 'FUNCTIONS_EXTENSION_VERSION'
          'value': '~3'
        }
        {
          'name': 'FUNCTIONS_WORKER_RUNTIME'
          'value': 'dotnet'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: storageConnectionString
        }
        // WEBSITE_CONTENTSHARE will also be auto-generated - https://docs.microsoft.com/en-us/azure/azure-functions/functions-app-settings#website_contentshare
        // WEBSITE_RUN_FROM_PACKAGE will be set to 1 by func azure functionapp publish
      ]
    }
  }
}
