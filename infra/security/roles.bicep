param acrName string
param aksPrincipalId string
param functionAppPrincipalId string
param keyVaultName string

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = if (!empty(acrName)) {
  name: acrName
}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

var acrPullDefinitionId = tenantResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '7f951dda-4ed3-4680-a7ca-43571c7d5f8b'
)
var kvSecretsDefinitionId = tenantResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '4633458b-17de-408a-b874-0445c86b69e6'
)

resource aksAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(acrName)) {
  name: guid(acr.id, aksPrincipalId, acrPullDefinitionId, 'v70')
  scope: acr
  properties: {
    principalId: aksPrincipalId
    roleDefinitionId: acrPullDefinitionId
    principalType: 'ServicePrincipal'
  }
}

resource funcKvSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kv.id, functionAppPrincipalId, kvSecretsDefinitionId, 'v70')
  scope: kv
  properties: {
    principalId: functionAppPrincipalId
    roleDefinitionId: kvSecretsDefinitionId
    principalType: 'ServicePrincipal'
  }
}
