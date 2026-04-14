targetScope = 'subscription'

param allowedSkuList array = [
  'Standard_B2s'
  'Standard_B2ms'
]

resource skuPolicy 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'limit-vm-skus'
  location: 'northeurope'
  properties: {
    displayName: 'Restrict VM sizes for cost control'

    policyDefinitionId: tenantResourceId(
      'Microsoft.Authorization/policyDefinitions',
      'cccc23c7-8427-4f53-ad12-b6a63eb452b3'
    )
    parameters: {
      listOfAllowedSKUs: {
        value: allowedSkuList
      }
    }
  }
}
