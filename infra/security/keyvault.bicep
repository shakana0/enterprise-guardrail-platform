param location string
param keyVaultName string = 'egp-kv'
param aksSubnetId string // Skickas in från main.bicep

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

    // HÄR LÅSER VI DÖRREN:
    networkAcls: {
      defaultAction: 'Deny' // Blockera allt som inte uttryckligen tillåts
      bypass: 'AzureServices' // Tillåt Azure-tjänster (som backup) att nå valvet
      virtualNetworkRules: [
        {
          id: aksSubnetId // Tillåt endast trafik från ditt AKS-subnät
        }
      ]
    }
  }
}

output keyVaultId string = kv.id
