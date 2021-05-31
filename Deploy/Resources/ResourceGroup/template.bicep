targetScope = 'subscription'

@description('Name of the Resource Group to create')
param rgName string

@description('Location for the Resource Group')
param rgLocation string = 'Australia Southeast'

@description('A condition to create a new resource group or not.')
param createNewRg bool = true

resource rgName_resource 'Microsoft.Resources/resourceGroups@2021-01-01' = if (createNewRg) {
  location: rgLocation
  name: rgName
  properties: {}
}
