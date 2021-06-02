param location string = 'tbd'
param keyVaultName string = 'tbd'
param functionAppName string = 'tbd'
param productionPrincipalId string
param productionTenantId string
param stagingPrincipalId string
param stagingTenantId string

@secure()
param storageConnectionString string = 'tbd'



resource keyVault 'Microsoft.KeyVault/vaults@2016-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: reference(resourceId('Microsoft.Web/sites', functionAppName), '2019-08-01', 'full').identity.tenantId
    accessPolicies: [
      {
        tenantId: productionTenantId
        objectId: productionPrincipalId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
      {
        tenantId: stagingTenantId
        objectId: stagingPrincipalId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }  
}


resource dbConnectionStringSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVaultName}/dbConnectionString'
  properties: {
    value: storageConnectionString
  }
  dependsOn:[
    keyVault
  ]
}

output dbConnectionStringUri string = dbConnectionStringSecret.properties.secretUri



