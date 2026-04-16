param location string
param spokeVnetName string

resource spokeVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: spokeVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.3.0.0/16'
      ]
    }
  }
}

output spokeVnetId string = spokeVnet.id
output spokeVnetName string = spokeVnet.name
