param vnetName string

resource aksSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: '${vnetName}/aks-subnet'
  properties: {
    addressPrefix: '10.1.1.0/24'
    serviceEndpoints: [
      {
        service: 'Microsoft.KeyVault'
      }
      {
        service: 'Microsoft.ServiceBus'
      }
    ]
  }
}

resource privateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: '${vnetName}/private-endpoints'
  properties: {
    addressPrefix: '10.1.2.0/24'
    privateEndpointNetworkPolicies: 'Disabled'
  }
}

output aksSubnetId string = aksSubnet.id
output aksSubnetName string = aksSubnet.name
