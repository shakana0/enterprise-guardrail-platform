param location string
param aksIdentityName string = 'egp-aks-identity'
param workloadIdentityName string = 'egp-workload-identity'

resource aksIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: aksIdentityName
  location: location
}

resource workloadIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: workloadIdentityName
  location: location
}

output aksIdentityId string = aksIdentity.id
output workloadIdentityId string = workloadIdentity.id
