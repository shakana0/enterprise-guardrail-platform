param location string = 'northeurope'

module hub './network/vnet-hub.bicep' = {
  name: 'hub-vnet'
  params: {
    location: location
  }
}

module spoke './network/vnet-spoke.bicep' = {
  name: 'spoke-vnet'
  params: {
    location: location
  }
}

module subnets './network/subnets.bicep' = {
  name: 'spoke-subnets'
  params: {
    vnetName: 'egp-spoke-vnet'
  }
}

module peering './network/peering.bicep' = {
  name: 'hub-spoke-peering'
  params: {
    hubVnetName: 'egp-hub-vnet'
    spokeVnetName: 'egp-spoke-vnet'
  }
}
