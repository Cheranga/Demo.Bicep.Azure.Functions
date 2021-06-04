param location string
param keyVaultName string
param productionPrincipalId string
param productionTenantId string
param stagingPrincipalId string
param stagingTenantId string

@secure()
param storageConnectionString string

resource keyVault 'Microsoft.KeyVault/vaults@2016-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: productionTenantId
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



