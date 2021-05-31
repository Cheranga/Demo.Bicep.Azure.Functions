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
    clientAffinityEnabled:true
    httpsOnly:true
    serverFarmId:planName
    siteConfig:{
      appSettings:[
        {
          name:'AzureWebJobsStorage'
          value:storageConnectionString
        }
      ]
    }
  }

  // resource appConfig 'config@2018-11-01' = {
  //   name: 'appsettings'
  //   properties: {
  //     AzureWebJobsStorage: storageConnectionString
  //   }
  // }  
}
