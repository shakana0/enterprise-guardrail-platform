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

resource funcSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  name: '${vnetName}/snet-function'
  properties: {
    addressPrefix: '10.1.3.0/24'
    serviceEndpoints: [
      { service: 'Microsoft.KeyVault' }
    ]
    delegations: [
      {
        name: 'webappDelegation'
        properties: {
          serviceName: 'Microsoft.Web/serverFarms'
        }
      }
    ]
  }
}

output funcSubnetId string = funcSubnet.id
output aksSubnetId string = aksSubnet.id
output aksSubnetName string = aksSubnet.name
