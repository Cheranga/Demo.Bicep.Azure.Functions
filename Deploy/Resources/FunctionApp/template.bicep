param funcAppName string
param location string
param planName string
param storageConnectionString string


resource funcApp 'Microsoft.Web/sites@2020-12-01' = {
  name: funcAppName
  kind:'functionapp'
  location:location
  identity:{
    type:'SystemAssigned'    
  }
  properties:{
    serverFarmId:planName
  }
  resource appConfig 'config@2020-12-01' = {
    name: 'appsettings'
    properties: {
      AzureWebJobsStorage: storageConnectionString
    }
  }  
}
