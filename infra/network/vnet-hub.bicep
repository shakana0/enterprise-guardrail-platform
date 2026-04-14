param location string
param hubVnetName string = 'egp-hub-vnet'

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: hubVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

output hubVnetId string = hubVnet.id
output hubVnetName string = hubVnet.name
