param location string
param keyVaultName string
param aksSubnetId string
param funcSubnetId string

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
      //defaultAction: 'Deny' // Block anything that is not explicitly allowed
      defaultAction: 'Allow'
      bypass: 'AzureServices' // Allow Azure services (like backup) to access the vault
      // virtualNetworkRules: [
      //   {
      //     id: aksSubnetId // Only allow traffic from your AKS subnet
      //   }
      //   {
      //     id: funcSubnetId
      //   }
      // ]
    }
  }
}

output keyVaultId string = kv.id
output keyVaultName string = kv.name
