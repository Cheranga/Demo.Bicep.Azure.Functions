@description('Name of Application Insights resource.')
param name string

@description('The location where the app insights will reside in.')
param rgLocation string = resourceGroup().location

resource appIns 'Microsoft.Insights/components@2020-02-02-preview' = {
  name:name
  kind:'web'
  location:rgLocation
  properties:{
    Application_Type:'web'
    Request_Source:'rest'
    Flow_Type:'Bluefield'
  }
}

output appInsightsKey string = reference(appIns.id, '2014-04-01').InstrumentationKey
