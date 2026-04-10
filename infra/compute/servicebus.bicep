param location string
param sbNamespaceName string = 'egp-sb'

resource sbNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: sbNamespaceName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
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
