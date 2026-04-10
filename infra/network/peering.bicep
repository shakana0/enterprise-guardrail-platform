param hubVnetName string
param spokeVnetName string

// Peering från hub → spoke
resource hubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  name: '${hubVnetName}/hub-to-spoke'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', spokeVnetName)
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

// Peering från spoke → hub
resource spokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  name: '${spokeVnetName}/spoke-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', hubVnetName)
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}
