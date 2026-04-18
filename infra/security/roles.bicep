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

var acrPullId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '7f951dda-4ed3-4680-a7ca-43fe172d538d'
)

var kvSecretsUserId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '4633458b-17de-408a-b874-0445c86b69e6'
)

resource aksAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(acrName)) {
  name: guid(acr.id, aksPrincipalId, acrPullId, 'final-v300')
  scope: acr
  properties: {
    principalId: aksPrincipalId
    roleDefinitionId: acrPullId
    principalType: 'ServicePrincipal'
  }
}

resource funcKvSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kv.id, functionAppPrincipalId, kvSecretsUserId, 'final-v300')
  scope: kv
  properties: {
    principalId: functionAppPrincipalId
    roleDefinitionId: kvSecretsUserId
    principalType: 'ServicePrincipal'
  }
}
