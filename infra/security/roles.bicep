param acrName string
param aksPrincipalId string
param functionAppPrincipalId string
param keyVaultName string

var acrId = '${subscription().id}/resourceGroups/${resourceGroup().name}/providers/Microsoft.ContainerRegistry/registries/${acrName}'
var kvId = '${subscription().id}/resourceGroups/${resourceGroup().name}/providers/Microsoft.KeyVault/vaults/${keyVaultName}'

var acrPullFullId = '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/7f951dda-4ed3-4680-a7ca-43571c7d5f8b'
var kvSecretsFullId = '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = if (!empty(acrName)) {
  name: acrName
}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource aksAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(acrName)) {
  name: guid(acrId, aksPrincipalId, acrPullFullId, 'v999')
  scope: acr
  properties: {
    principalId: aksPrincipalId
    roleDefinitionId: acrPullFullId
    principalType: 'ServicePrincipal'
  }
}

resource funcKvSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kvId, functionAppPrincipalId, kvSecretsFullId, 'v999')
  scope: kv
  properties: {
    principalId: functionAppPrincipalId
    roleDefinitionId: kvSecretsFullId
    principalType: 'ServicePrincipal'
  }
}
