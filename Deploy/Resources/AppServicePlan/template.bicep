param planName string
param planLocation string = resourceGroup().location
param planSku string ='Y1'
param planTier string = 'Dynamic'

resource blah 'Microsoft.Web/serverfarms@2020-12-01' = {
  name:planName
  location:planLocation
  sku:{
    name:planSku
    tier:planTier
  }
}
