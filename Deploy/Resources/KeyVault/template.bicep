param keyVaultName string = 'tbd'
param functionAppName string = 'tbd'
param location string = 'tbd'

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
        tenantId: reference(resourceId('Microsoft.Web/sites', functionAppName), '2019-08-01', 'full').identity.tenantId
        objectId: reference(resourceId('Microsoft.Web/sites', functionAppName), '2019-08-01', 'full').identity.principalId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
      {
        tenantId: reference(resourceId('Microsoft.Web/sites/slots', functionAppName, 'Staging'), '2019-08-01', 'full').identity.tenantId
        objectId: reference(resourceId('Microsoft.Web/sites/slots', functionAppName, 'Staging'), '2019-08-01', 'full').identity.principalId
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


resource dbConnectionString 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVaultName}/dbConnectionString'
  properties: {
    value: storageConnectionString
  }
}

output dbConnectionStringUri string = dbConnectionString.properties.secretUri



