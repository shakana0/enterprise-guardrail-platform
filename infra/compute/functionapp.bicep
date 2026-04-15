param location string
param functionAppName string
param keyVaultName string
// param funcSubnetId string
param appServicePlanId string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource functionApp 'Microsoft.Web/sites@2023-12-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    // virtualNetworkSubnetId: funcSubnetId
    reserved: true
    siteConfig: {
      linuxFxVersion: 'DOTNET-ISOLATED|10.0'
      vnetRouteAllEnabled: true
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: '@Microsoft.KeyVault(SecretUri=${kv.properties.vaultUri}secrets/StorageConnectionString/)'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'ServiceBusConnection'
          value: '@Microsoft.KeyVault(SecretUri=${kv.properties.vaultUri}secrets/ServiceBusConnection/)'
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: '@Microsoft.KeyVault(SecretUri=${kv.properties.vaultUri}secrets/AppInsightsConnectionString/)'
        }
      ]
    }
    httpsOnly: true
  }
}

output principalId string = functionApp.identity.principalId
