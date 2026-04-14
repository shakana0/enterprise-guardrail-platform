targetScope = 'subscription'

param allowedSkuList array = [
  'Standard_B2s'
  'Standard_B2ms'
]

resource skuPolicy 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'limit-vm-skus'
  properties: {
    displayName: 'Restrict VM sizes for cost control'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad87-de6164b3f073' // Inbyggd definition för tillåtna SKU:er
    parameters: {
      listOfAllowedSKUs: {
        value: allowedSkuList
      }
    }
  }
}
