// param location string
// param sbNamespaceName string = 'egp-sb'
// param aksSubnetId string // Skickas in från main.bicep

// resource sbNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
//   name: sbNamespaceName
//   location: location
//   sku: {
//     name: 'Premium' // Krävs för nätverksisolering
//     tier: 'Premium'
//     capacity: 1 // Minsta möjliga för Premium
//   }
// }

// // Lås ner Service Bus till ditt subnät
// resource networkRuleSet 'Microsoft.ServiceBus/namespaces/networkRuleSets@2022-10-01-preview' = {
//   name: 'default'
//   parent: sbNamespace
//   properties: {
//     defaultAction: 'Deny'
//     virtualNetworkRules: [
//       {
//         subnet: {
//           id: aksSubnetId
//         }
//         ignoreMissingVnetServiceEndpoint: false
//       }
//     ]
//   }
// }

// resource sbQueue 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
//   name: 'events'
//   parent: sbNamespace
//   properties: {
//     enablePartitioning: false
//   }
// }

// output serviceBusId string = sbNamespace.id

param location string
param sbNamespaceName string = 'egp-sb'

resource sbNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: sbNamespaceName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource sbQueue 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
  name: 'events'
  parent: sbNamespace
  properties: {
    enablePartitioning: false
  }
}

output serviceBusId string = sbNamespace.id
