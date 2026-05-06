# 🔐 Security & Identity Strategy

The Enterprise Guardrail Platform (EGP) is built on the principle of **Zero-Trust**—never trust, always verify. This document outlines how we have eliminated common security risks like static credentials and open network paths through automated identity management and isolation.

---

## 🔐 Identity & Access Flow (Visualized)

> [!TIP]
> **Security Walkthrough:** Our Zero-Trust model shifts the focus from "secret-sharing" to "identity-validation". By leveraging OpenID Connect (OIDC) for deployments and Managed Identities for runtime, we eliminate the risk of leaked credentials and ensure that every service access is explicitly authorized via RBAC.

<p align="center">
  <img src="./assets/security.png" width="800" alt="Security and Identity Access Flow" />
</p>

---

## 🆔 Identity-Driven Access (Passwordless)

We have completely eliminated the need for static passwords, connection strings, or service principal keys within our application code and configuration.

- **Managed Identities**: All compute resources utilize Azure Managed Identities for secure, keyless authentication.
- **Workload Identity**: The AKS cluster is configured with **Workload Identity**, allowing pods to inherit Azure identities for granular access control.
- **OIDC for CI/CD**: Our GitHub Actions workflows use **OpenID Connect (OIDC)** to authenticate with Azure, removing the need to store long-lived secrets in GitHub.

---

## 🗝️ Secret Management & RBAC

Even in a passwordless environment, some integrations require keys. We manage these using **Azure Key Vault** with **Role-Based Access Control (RBAC)**.

- **RBAC Authorization**: The Key Vault is configured for RBAC authorization, replacing legacy access policies with granular Azure roles.
- **Least Privilege**:
  - The Function App is granted the **Key Vault Secrets User** role to read specific secrets.
  - The AKS cluster is granted the **AcrPull** role to pull container images from the private registry securely.
- **Automated Injection**: Connection strings are automatically pushed to Key Vault as secrets during deployment, and retrieved by services via secure **Key Vault References**.

---

## 🌐 Network Security & Isolation

The platform's network architecture is designed to minimize the attack surface by ensuring traffic stays within the private Azure backbone.

- **Hub-and-Spoke Isolation**: All workloads are placed in a **Spoke VNet**, isolated from the central **Hub VNet** and the public internet.
- **Service Endpoints**: We utilize Service Endpoints for **Key Vault** and **Service Bus** on the AKS and Function subnets to ensure traffic never traverses the public internet.
- **Private DNS**: Dedicated Private DNS Zones are established to support internal name resolution and future Private Link integrations.

---

## 📦 Container Security

- **Private Registry**: The **Azure Container Registry (ACR)** is locked down with administrative access disabled; access is strictly managed via Managed Identity.
- **Multi-Stage Builds**: Our Dockerfiles use a multi-stage approach to ensure production images contain only necessary binaries, reducing the attack surface.

---

## 🛠️ Security Guardrails (Policy)

To prevent security misconfigurations, we use **Azure Policy** enforced at the subscription level.

- **SKU Enforcement**: Only approved, cost-effective VM sizes are allowed to prevent unmanaged resource sprawl.
- **HTTPS Only**: All web-based resources are strictly configured to enforce **HTTPS-only** traffic.

---

## 🛡️ Security Summary

| Layer        | Strategy     | Implementation                          |
| :----------- | :----------- | :-------------------------------------- |
| **Identity** | Passwordless | Managed Identity (User & System) & OIDC |
| **Secrets**  | Centralized  | Key Vault with RBAC                     |
| **Network**  | Isolated     | Hub-and-Spoke & Service Endpoints       |
| **Compute**  | Hardened     | Multi-stage Docker & Workload Identity  |
