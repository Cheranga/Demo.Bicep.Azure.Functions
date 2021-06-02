targetScope = 'subscription'

@description('Name of the Resource Group to create')
param rgName string

@description('Location for the Resource Group')
param rgLocation string = 'Australia Southeast'

resource rgName_resource 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  location: rgLocation
  name: rgName
  properties: {}
}
