# 💰 FinOps & Cost Governance

In the Enterprise Guardrail Platform (EGP), cost management is treated as a technical requirement on par with security and performance. This document details the strategies implemented to ensure maximum cloud value with minimum waste.

---

## 📈 Consumption-Based Strategy

The platform is architected to scale with demand, ensuring that costs are tightly coupled with actual usage.

- **Serverless Scaling**: The Azure Function App utilizes the **Consumption (Y1) plan**, which scales to zero when no messages are being processed, eliminating idle costs
- **Spot Instance Integration**: The AKS cluster is designed to leverage **Spot instances** for its compute nodes, offering up to 90% savings compared to standard pay-as-you-go pricing.
- **Minimal API Design**: The .NET 10 API is built for high efficiency, reducing the CPU and memory footprint required for each container instance.

---

## 🛠️ Automated Hibernation (The "Zero-Waste" Lifecycle)

To optimize non-production environments, the platform implements automated schedules to shut down compute resources during off-hours.

### 1. Nightly Shutdown (`aks-stop.yml`)

- **Schedule**: Runs at **20:00 UTC** every night.
- **Mechanism**: Executes a command to stop the AKS cluster nodes while maintaining the configuration.
- **Saving**: Reduces daily compute costs by approximately 60% by not running during inactive hours.

### 2. Morning Startup (`aks-start.yml`)

- **Schedule**: Runs at **09:00 UTC** every morning.
- **Mechanism**: Restarts the cluster nodes, ensuring the environment is ready for the development team.

---

## 🛡️ Governance & Guardrails

We prevent "cost sprawl" through automated enforcement at the infrastructure level.

- **Subscription Budgets**: A platform budget is deployed via Bicep and set to **100 SEK**.
  - **Alerting**: Automated notifications are sent to the owner when actual spend reaches 80% or when the forecast exceeds the 100% threshold.
- **Azure Policy SKU Control**: A subscription-level policy restricts the creation of expensive virtual machine sizes.
  - **Permitted SKUs**: Only cost-efficient types like `Standard_B2s` and `Standard_B2ms` are allowed in the environment.

---

## 🔍 Observability & Optimization

- **Log Ingestion Sampling**: Application Insights is configured in `host.json` to use **Sampling Settings**, reducing the volume of log data sent to the workspace and lowering ingestion costs.
- **Shared Log Analytics**: A centralized Log Analytics Workspace is used across all components to minimize management overhead and storage fragmentation.

---

## 🎯 Financial Impact Summary

| Feature             | Cost Impact                | Implementation              |
| :------------------ | :------------------------- | :-------------------------- |
| **AKS Hibernation** | ~60% Daily Savings         | GitHub Actions + Azure CLI  |
| **Spot Instances**  | Up to 90% Compute Savings  | AKS Bicep Module            |
| **Budgeting**       | Prevents Billing Surprises | Subscription-level Budget   |
| **Serverless**      | Zero Cost when Idle        | Azure Functions Consumption |
