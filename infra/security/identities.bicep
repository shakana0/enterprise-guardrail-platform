param location string
param aksIdentityName string
param workloadIdentityName string

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
output aksIdentityPrincipalId string = aksIdentity.properties.principalId
