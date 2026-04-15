param appServicePlanName string
param location string

// Consumption Plan / Serverless
resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  sku: { name: 'Y1', tier: 'Dynamic' }
  properties: { reserved: true }
}

output appServicePlanId string = appServicePlan.id
