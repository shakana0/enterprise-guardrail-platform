param acrName string
param aksPrincipalId string
param functionAppPrincipalId string
param keyVaultName string

// Get reference to the existing resources
resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: acrName
}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

// Definition for the AcrPull role (Built-in Azure)
// var acrPullRoleDefinitionId = subscriptionResourceId(
//   'Microsoft.Authorization/roleDefinitions',
//   '7f951dda-4ed3-4680-a7ca-43571c7d5f8b'
// )

//Key Vault Secrets User
var kvSecretsUserRoleDefinitionId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '4633458b-17de-408a-b874-0445c86b69e6'
)

// resource aksAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(acr.id, aksPrincipalId, 'AcrPull')
//   scope: acr
//   properties: {
//     principalId: aksPrincipalId
//     roleDefinitionId: acrPullRoleDefinitionId
//     principalType: 'ServicePrincipal'
//   }
//}

//Function App -> Key Vault Secrets User
resource funcKvSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kv.id, functionAppPrincipalId, 'KeyVaultSecretsUser')
  scope: kv
  properties: {
    roleDefinitionId: kvSecretsUserRoleDefinitionId
    principalId: functionAppPrincipalId
    principalType: 'ServicePrincipal'
  }
}
