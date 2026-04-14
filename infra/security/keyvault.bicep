param location string
param keyVaultName string = 'egp-kv-jh-2026'
param aksSubnetId string

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    enableRbacAuthorization: true

    // HERE WE LOCK THE DOOR:
    networkAcls: {
      defaultAction: 'Deny' // Block anything that is not explicitly allowed
      bypass: 'AzureServices' // Allow Azure services (like backup) to access the vault
      virtualNetworkRules: [
        {
          id: aksSubnetId // Only allow traffic from your AKS subnet
        }
      ]
    }
  }
}

output keyVaultId string = kv.id
