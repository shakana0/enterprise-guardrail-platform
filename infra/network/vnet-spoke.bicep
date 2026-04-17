param location string
param spokeVnetName string

resource spokeVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: spokeVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.3.0.0/16']
    }
    subnets: [
      {
        name: 'aks-subnet'
        properties: {
          addressPrefix: '10.3.1.0/24'
          serviceEndpoints: [{ service: 'Microsoft.KeyVault' }, { service: 'Microsoft.ServiceBus' }]
        }
      }
      {
        name: 'private-endpoints'
        properties: {
          addressPrefix: '10.3.2.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: 'snet-function'
        properties: {
          addressPrefix: '10.3.3.0/24'
          serviceEndpoints: [{ service: 'Microsoft.KeyVault' }]
        }
      }
    ]
  }
}

output aksSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', spokeVnetName, 'aks-subnet')
output funcSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', spokeVnetName, 'snet-function')
output aksSubnetName string = 'aks-subnet'
