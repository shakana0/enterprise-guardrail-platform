<div align="center">

# The Enterprise Guardrail Platform (EGP)

> **A Self-Healing, Cost-Aware Foundation for Modern Cloud Workloads.**

The Enterprise Guardrail Platform is a high-performance, secure, and FinOps-optimized cloud foundation built on Azure. It is designed to solve the friction between developer velocity and enterprise governance by providing a "Secure-by-Design" environment.

[![Azure](https://img.shields.io/badge/Azure-Cloud--Native-0089D6?logo=microsoftazure)](https://azure.microsoft.com)
[![Bicep](https://img.shields.io/badge/Infrastructure-Bicep%20(IaC)-B15DA1)](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
[![FinOps](https://img.shields.io/badge/FinOps-Optimized-brightgreen)](https://www.finops.org/)

---

### 🗺️ Platform Navigation

[📋 Requirements](docs/REQUIREMENTS.md) • [🏗️ Architecture](docs/ARCHITECTURE.md) • [🔐 Security](docs/SECURITY.md) • [🎯 FinOps](docs/FINOPS.md) • [🛠️ Infrastructure](docs/INFRASTRUCTURE.md) • [🚀 CI/CD](docs/WORKFLOW.md)

---

</div>

## 🎯 Executive Summary

Modern organizations struggle to balance innovation speed with cloud governance. This MVP demonstrates a **Platform Engineering** approach to Azure, focusing on three pillars:

- **Security & Governance:** A Zero-Trust foundation using Hub-and-Spoke networking and Identity-driven access.
- **Scalability & Efficiency:** A hybrid compute model combining **AKS** (for persistent APIs) and **Azure Functions** (for event-driven processing).
- **Cost Control (FinOps):** Automated environment hibernation and policy-driven resource constraints.

---

## 🏗️ Architectural Blueprint & Topology

> [!TIP]
> **Architecture Walkthrough:** The EGP follows a Hub-and-Spoke topology to enforce a clear boundary between platform management and application workloads. This design ensures that all traffic is governed by centralized security policies while allowing the Spoke environments to scale independently.

<p align="center">
  <img src="./assets/architecture.png" width="800" alt="Hub-and-Spoke Architecture Diagram" />
</p>

---

The platform utilizes a **Hub-and-Spoke** topology to ensure strict network isolation and centralized traffic control.

- **Hub VNet:** Centralized management and shared services.
- **Spoke VNet:** Isolated workload environments for AKS and Serverless components.
- **Event Pipeline:** .NET 10 API (AKS) → Azure Service Bus → QueueProcessor (Functions).

---

## 🧠 Architectural Core Principles

### 1. Identity over Secrets (Zero Trust)

We eliminate static credentials. All services use **User-Assigned Managed Identities** to authenticate.

- **AKS** pulls images from ACR via Managed Identity.
- **Functions** retrieve connection strings from Key Vault via RBAC—no secrets are stored in app settings.

### 2. FinOps: The "Hibernation" Strategy

To optimize spend, the platform implements automated lifecycle management:

- **Automated Scaling:** AKS nodes scale based on demand via KEDA.
- **Daily Hibernation:** GitHub Actions trigger `az aks stop/start` to reduce compute costs by ~60% during off-hours.

### 3. Infrastructure as Code (IaC)

The entire state is defined in **Modular Bicep**, ensuring 100% reproducibility and eliminating configuration drift.

---

## 🏁 Documentation Deep-Dives

- [📋 **Platform Requirements**](docs/REQUIRMENTS.md) - Functional and non-functional benchmarks for a production-ready state.
- [🏗️ **Architecture**](docs/ARCHITECTURE.md) - Hub-and-Spoke & VNet Peering.
- [🔐 **Security & Identity**](docs/SECURITY.md) - RBAC, Managed Identities, and Key Vault.
- [🎯 **FinOps & Governance**](docs/FINOPS.md) - Budgeting, Policies, and Automation.
- [🛠️ **Infrastructure**](docs/INFRASTRUCTURE.md) - Bicep modules and resource definitions.
- [🚀 **CI/CD**](docs/WORKFLOW.md) - GitHub Actions workflows and deployment triggers.
