param acrName string
param aksPrincipalId string
param functionAppPrincipalId string
param keyVaultName string
param acrPullRoleId string
#disable-next-line secure-secrets-in-params
param kvSecretsUserRoleId string

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = if (!empty(acrName)) {
  name: acrName
}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource aksAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(acrName)) {
  name: guid(acr.id, aksPrincipalId, acrPullRoleId)
  scope: acr
  properties: {
    principalId: aksPrincipalId
    roleDefinitionId: acrPullRoleId
    principalType: 'ServicePrincipal'
  }
}

resource funcKvSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kv.id, functionAppPrincipalId, kvSecretsUserRoleId)
  scope: kv
  properties: {
    principalId: functionAppPrincipalId
    roleDefinitionId: kvSecretsUserRoleId
    principalType: 'ServicePrincipal'
  }
}
