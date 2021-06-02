param location string = 'tbd'
param rgName string = 'tbd'
param functionAppName string = 'tbd'
param planName string = 'tbd'

resource functionAppResource 'Microsoft.Web/sites@2020-12-01' = {
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

resource functionAppStagingSlot 'Microsoft.Web/sites/slots@2016-08-01' = {
  name: '${functionAppResource.name}/Staging'
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: planName
  }
  dependsOn:[
    functionAppResource
  ]
}


output prodFunctionAppName string = functionAppResource.name
output stagingFunctionAppName string = functionAppStagingSlot.name
output productionTenantId string = functionAppResource.identity.tenantId
output productionPrincipalId string = functionAppResource.identity.principalId
output stagingTenantId string = functionAppStagingSlot.identity.tenantId
output stagingPrincipalId string = functionAppStagingSlot.identity.principalId

output masterKey string = listkeys('${resourceId(rgName, 'Microsoft.Web/sites', functionAppName)}/host/default', '2018-11-01').masterKey
