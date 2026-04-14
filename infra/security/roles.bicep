param acrName string
param aksPrincipalId string

// Get reference to the existing ACR
resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: acrName
}

// Definition for the AcrPull role (Built-in Azure)
var acrPullRoleDefinitionId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '7f951dda-4ed3-4680-a7ca-43571c7d5f8b'
)

resource aksAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, aksPrincipalId, 'AcrPull')
  scope: acr
  properties: {
    principalId: aksPrincipalId
    roleDefinitionId: acrPullRoleDefinitionId
    principalType: 'ServicePrincipal'
  }
}
