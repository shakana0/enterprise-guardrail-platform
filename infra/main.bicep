targetScope = 'subscription'

param location string = 'northeurope'
param rgName string = 'egp-platform-rg'

@secure()
param alertEmail string

// 1. create RG
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: rgName
  location: location
}

// 2. Governance: Apply subscription-level policies for cost control
module governancePolicy './governance/policy.bicep' = {
  name: 'platform-policy'
}

// 3. Network: Hub & Spoke
module hub './network/vnet-hub.bicep' = {
  name: 'hub-vnet'
  scope: rg
  params: {
    location: location
  }
}

module spoke './network/vnet-spoke.bicep' = {
  name: 'spoke-vnet'
  scope: rg
  params: {
    location: location
  }
}

module subnets './network/subnets.bicep' = {
  name: 'spoke-subnets'
  scope: rg
  params: {
    vnetName: spoke.outputs.spokeVnetName
  }
}

module peering './network/peering.bicep' = {
  name: 'network-peering'
  scope: rg
  params: {
    hubVnetName: hub.outputs.hubVnetName
    hubVnetId: hub.outputs.hubVnetId
    spokeVnetName: spoke.outputs.spokeVnetName
    spokeVnetId: spoke.outputs.spokeVnetId
  }
}

// 4. Security & Monitoring
module identities './security/identities.bicep' = {
  name: 'compute-identities'
  scope: rg
  params: {
    location: location
  }
}

// module roleAssignments './security/roles.bicep' = {
//   name: 'role-assignments'
//   scope: rg
//   params: {
//      acrName: acr.outputs.acrName
//     aksPrincipalId: identities.outputs.aksIdentityPrincipalId
//   }
// }

module logging './monitor/logging.bicep' = {
  name: 'monitor-logging'
  scope: rg
  params: {
    location: location
  }
}

module keyvault './security/keyvault.bicep' = {
  name: 'compute-kv'
  scope: rg
  params: {
    location: location
    aksSubnetId: subnets.outputs.aksSubnetId
  }
}

// 5. Container Registry & AKS
// module acr './registry/acr.bicep' = {
//   name: 'compute-acr'
//   scope: rg
//   params: {
//     location: location
//      acrName: 'egpstud26acr'
//   }
// }

// module aks './compute/aks.bicep' = {
//   name: 'compute-aks'
//   scope: rg
//   params: {
//     location: location
//     aksIdentityId: identities.outputs.aksIdentityId
//     workloadIdentityId: identities.outputs.workloadIdentityId
//     vnetName: spoke.outputs.spokeVnetName
//     aksSubnetName: subnets.outputs.aksSubnetName
//   }
// }

// 6. Messaging & Cost control
module servicebus './messaging/servicebus.bicep' = {
  name: 'compute-sb'
  scope: rg
  params: {
    location: location
  }
}

module platformBudget './governance/budget.bicep' = {
  name: 'platform-budget-deploy'
  scope: rg
  params: {
    budgetAmount: 100
    emailAddress: alertEmail
  }
}
