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

module identities './security/identities.bicep' = {
  name: 'compute-identities'
  params: {
    location: location
  }
}

module acr './registry/acr.bicep' = {
  name: 'compute-acr'
  params: {
    location: location
  }
}

module keyvault './compute/keyvault.bicep' = {
  name: 'compute-kv'
  params: {
    location: location
  }
}

module servicebus './compute/servicebus.bicep' = {
  name: 'compute-sb'
  params: {
    location: location
  }
}

module aks './compute/aks.bicep' = {
  name: 'compute-aks'
  params: {
    location: location
    aksIdentityId: identities.outputs.aksIdentityId
    workloadIdentityId: identities.outputs.workloadIdentityId
    vnetName: 'egp-spoke-vnet'
  }
}
