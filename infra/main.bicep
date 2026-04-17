targetScope = 'subscription'

param location string = 'swedencentral'
param rgName string = 'egp-platform-rg'
param deploymentTime string = utcNow('yyyyMMddHHmm')
var naming = {
  keyVaultName: 'egp-kv-jh-2026'
  funcAppName: 'egp-func-jh-2026'
  aksSubnetName: 'aks-subnet-v3'
  aksName: 'egp-aks'
  funcSubnetName: 'snet-function-v3'
  sbNamespaceName: 'egp-sb-jh-2026'
  appInsightsName: 'egp-ai-jh-2026'
  workspaceName: 'egp-log-jh-2026'
  hubVnetName: 'egp-hub-vnet'
  spokeVnetName: 'egp-spoke-vnet-v3'
  acrName: 'egpstud26acr'
  aksIdentityName: 'egp-aks-identity'
  workloadIdentityName: 'egp-workload-identity'
  functionAppName: 'egp-func-jh-2026'
  appServicePlanName: 'egp-asp-jh-2026'
  storageAccountName: 'egpstoragejh2026'
}

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
module spoke './network/vnet-spoke.bicep' = {
  name: 'spoke-vnet-${deploymentTime}'
  scope: rg
  params: {
    location: location
    spokeVnetName: naming.spokeVnetName
  }
}

// module subnets './network/subnets.bicep' = {
//   name: 'spoke-subnets-${deploymentTime}'
//   scope: rg
//   params: {
//     vnetName: naming.spokeVnetName
//   }
// }

module hub './network/vnet-hub.bicep' = {
  name: 'hub-vnet'
  scope: rg
  params: {
    location: location
    hubVnetName: naming.hubVnetName
  }
}

// module peering './network/peering.bicep' = {
//   name: 'network-peering'
//   scope: rg
//   params: {
//     hubVnetName: hub.outputs.hubVnetName
//     hubVnetId: hub.outputs.hubVnetId
//     spokeVnetName: spoke.outputs.spokeVnetName
//     spokeVnetId: spoke.outputs.spokeVnetId
//   }
//   dependsOn: [
//     subnets
//   ]
// }

// 4. Security & Monitoring
module identities './security/identities.bicep' = {
  name: 'compute-identities'
  scope: rg
  params: {
    location: location
    aksIdentityName: naming.aksIdentityName
    workloadIdentityName: naming.workloadIdentityName
  }
}

module logging './monitor/logging.bicep' = {
  name: 'monitor-logging'
  scope: rg
  params: {
    location: location
    appInsightsName: naming.appInsightsName
    workspaceName: naming.workspaceName
  }
}

module keyvault './security/keyvault.bicep' = {
  name: 'compute-kv'
  scope: rg
  params: {
    location: location
    aksSubnetId: spoke.outputs.aksSubnetId
    funcSubnetId: spoke.outputs.funcSubnetId
    keyVaultName: naming.keyVaultName
  }
}

// 5. Container Registry & AKS
module acr './registry/acr.bicep' = {
  name: 'acr-deploy-${deploymentTime}'
  scope: rg
  params: {
    location: location
    acrName: naming.acrName
  }
}

// module aks './compute/aks.bicep' = {
//   name: 'compute-aks'
//   scope: rg
//   params: {
//     location: location
//     aksIdentityId: identities.outputs.aksIdentityId
//     workloadIdentityId: identities.outputs.workloadIdentityId
//     vnetName: naming.spokeVnetName
//     aksSubnetName: spoke.outputs.aksSubnetName
//     aksName: naming.aksName
//   }
// }

// 6. Compute & Storage: Core resources for the Function App
module storage './storage/storage-account.bicep' = {
  name: 'storage-deploy'
  scope: rg
  params: {
    location: location
    storageAccountName: naming.storageAccountName
    keyVaultName: naming.keyVaultName
  }
  dependsOn: [
    keyvault
  ]
}

module appServicePlan './compute/app-service-plan.bicep' = {
  name: 'plan-deploy'
  scope: rg
  params: {
    location: location
    appServicePlanName: naming.appServicePlanName
  }
}

module functionApp './compute/functionapp.bicep' = {
  name: 'functionAppDeploy'
  scope: rg
  params: {
    location: location
    functionAppName: naming.funcAppName
    keyVaultName: keyvault.outputs.keyVaultName
    // funcSubnetId: spoke.outputs.funcSubnetId
    appServicePlanId: appServicePlan.outputs.appServicePlanId
  }
  dependsOn: [
    storage
  ]
}

// 7. Roles
module roleAssignments './security/roles.bicep' = {
  name: 'role-assignments-${deploymentTime}'
  scope: rg
  params: {
    acrName: naming.acrName
    aksPrincipalId: identities.outputs.aksIdentityPrincipalId
    functionAppPrincipalId: functionApp.outputs.principalId
    keyVaultName: keyvault.outputs.keyVaultName
    deploymentTime: deploymentTime
  }
  dependsOn: [
    acr
  ]
}

// 8. Messaging & Cost control
module servicebus './messaging/servicebus.bicep' = {
  name: 'compute-sb'
  scope: rg
  params: {
    location: location
    sbNamespaceName: naming.sbNamespaceName
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
