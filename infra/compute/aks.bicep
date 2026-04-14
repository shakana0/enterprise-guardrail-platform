param location string
param aksName string = 'egp-aks'
param aksIdentityId string
param workloadIdentityId string
param vnetName string
param aksSubnetName string = 'aks-subnet'

resource aks 'Microsoft.ContainerService/managedClusters@2023-07-01' = {
  name: aksName
  location: location
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${aksIdentityId}': {}
    }
  }
  properties: {
    dnsPrefix: 'egpaks'

    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      serviceCidrs: [
        '10.2.0.0/24'
      ]
      dnsServiceIP: '10.2.0.10'
      loadBalancerSku: 'standard'
      outboundType: 'loadBalancer'
    }

    identityProfile: {
      kubeletidentity: {
        resourceId: workloadIdentityId
      }
    }

    agentPoolProfiles: [
      {
        name: 'systempool'
        vmSize: 'Standard_B2s'
        count: 1
        mode: 'System'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        vnetSubnetID: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, aksSubnetName)
        scaleSetPriority: 'Spot'
        scaleSetEvictionPolicy: 'Delete'
        spotMaxPrice: -1
      }
    ]
  }
}

output aksId string = aks.id
