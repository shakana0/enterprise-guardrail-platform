param budgetAmount int = 100
param emailAddress string

resource budget 'Microsoft.Consumption/budgets@2023-05-01' = {
  name: 'Monthly-MVP-Budget'
  properties: {
    timeGrain: 'Monthly'
    category: 'Cost'
    amount: budgetAmount
    timePeriod: {
      startDate: '2026-04-01'
      endDate: '2026-12-31'
    }
    notifications: {
      Actual_80_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 80
        contactEmails: [
          emailAddress
        ]
        thresholdType: 'Actual'
      }
      Forecasted_100_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 100
        contactEmails: [
          emailAddress
        ]
        thresholdType: 'Forecasted'
      }
    }
  }
}
