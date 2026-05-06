# 📋 Platform Requirements

This document outlines the Functional and Non-Functional requirements for the Enterprise Guardrail Platform (EGP). These requirements serve as the benchmark for the platform's "Production-Ready" status.

---

## 🏗️ Functional Requirements (FR)

### 1. Ingress & API Management

- The platform must provide a RESTful API endpoint to receive incoming data payloads.
- The API must be containerized and orchestrated via a managed Kubernetes service (AKS).
- The API must support health probes for automated self-healing by the orchestrator.

### 2. Asynchronous Messaging

- The system must decouple the API from the processing layer using a message broker.
- Messages must be persisted in a queue to ensure durability during traffic spikes.

### 3. Serverless Processing

- The platform must include a background worker that triggers automatically upon message arrival.
- The worker must run in a serverless environment to optimize resource utilization.

### 4. Automated Governance

- The platform must enforce resource constraints via subscription-level policies.
- A budget must be active, with automated alerts triggered at 80% and 100% thresholds.

---

## ⚙️ Non-Functional Requirements (NFR)

### 1. Security (Zero-Trust)

- **Authentication**: No static passwords or connection strings shall be stored in application settings or code.
- **Authorization**: Access to cloud resources (Key Vault, ACR, Service Bus) must be managed via Managed Identities and RBAC.
- **Network Isolation**: Workloads must be isolated within a Spoke VNet, using Service Endpoints to keep traffic off the public internet.

### 2. Cost Efficiency (FinOps)

- **Compute Optimization**: AKS system pools must utilize Spot instances to reduce costs.
- **Automated Hibernation**: Non-production clusters must be stopped during off-hours via automation.
- **Scaling**: The processing layer must scale to zero when idle.

### 3. Scalability & Performance

- The API layer must support horizontal scaling via the orchestrator.
- The messaging layer must support standard-tier performance for reliable message delivery.

### 4. Maintainability (IaC)

- 100% of the infrastructure must be defined as Bicep code.
- Deployment must be fully automated via a CI/CD pipeline using secure OIDC authentication.

---

## 🎯 Compliance Summary

| Requirement Category | Implementation Strategy                | Status |
| :------------------- | :------------------------------------- | :----- |
| **Identity**         | Managed Identities (User-Assigned)     | ✅     |
| **Networking**       | Hub-and-Spoke Topology                 | ✅     |
| **Deployment**       | GitHub Actions with OIDC               | ✅     |
| **FinOps**           | Scheduled Hibernation & Spot Instances | ✅     |
