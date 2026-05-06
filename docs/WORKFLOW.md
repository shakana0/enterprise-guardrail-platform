# 🚀 Workflow & CI/CD Automation

This document details the automated processes that drive the Enterprise Guardrail Platform (EGP), from infrastructure deployment to cost-saving lifecycle management.

---

## 🚀 Lifecycle & Automation (Visualized)

> [!TIP]
> **Automation Walkthrough:** The platform's lifecycle is entirely event-driven. From code-quality gates triggered on Pull Requests to automated FinOps "hibernation" schedules, our GitHub Actions pipelines ensure that the infrastructure state remains consistent with our Bicep definitions without manual intervention.

<p align="center">
  <img src="./assets/workflow.png" width="800" alt="CI/CD and Automation Pipelines" />
</p>

---

## 🔒 Secure Authentication (OIDC)

All GitHub Actions workflows interact with Azure using **OpenID Connect (OIDC)**.

- **Keyless Security**: By using `permissions: id-token: write`, we eliminate the need for storing long-lived Azure Service Principal secrets in GitHub.
- **Scoped Access**: The workflows use specific Client, Tenant, and Subscription IDs to maintain a secure connection.

---

## 🛠️ Deployment Workflow (`deploy.yml`)

The core of the platform's automation is the deployment pipeline that synchronizes the infrastructure state.

- **Infrastructure as Code**: The workflow triggers on every push to the `main` branch
- **Subscription-Level Deployment**: It executes `az deployment sub create`, deploying the entire stack—including Resource Groups and Policies—from the `main.bicep` entry point.
- **Concurrency Control**: Uses `concurrency` groups to prevent multiple simultaneous deployments from causing resource locks.

---

## 💰 FinOps: Lifecycle Automation

To minimize operational costs, the platform implements automated "hibernation" schedules for the AKS cluster.

### 1. AKS Stop Workflow (`aks-stop.yml`)

- **Schedule**: Runs automatically at **20:00 UTC** every night.
- **Action**: Executes `az aks stop` to deallocate all virtual machine nodes in the `egp-aks` cluster.
- **Impact**: Stops compute charges while preserving the cluster configuration.

### 2. AKS Start Workflow (`aks-start.yml`)

- **Schedule**: Runs automatically at **09:00 UTC** every morning.
- **Action**: Executes `az aks start` to bring the cluster back to a "Ready" state before business hours.
- **Manual Override**: Both workflows support `workflow_dispatch` for manual control during off-hours.

---

## 🏗️ Build & Quality Assurance (`build.yml`)

Ensures that all application code meets quality standards before it is considered for deployment.

- **Continuous Integration**: Triggers on both `push` to main and `pull_request` events.
- **Modern SDK**: Utilizes the **.NET 10.0.x** setup for building the API and Function projects.
- **Validation**: Executes `dotnet restore` and `dotnet build` to verify code integrity.

---

## 🧪 PR Environments (`pr-env.yml`)

- **Dynamic Environments**: Triggers when a Pull Request is opened or reopened.
- **Isolation**: Designed to create temporary namespaces or environments for testing changes in isolation before merging to the main branch.

---

## 📊 Workflow Summary

| Workflow      | Trigger          | Primary Responsibility               |
| :------------ | :--------------- | :----------------------------------- |
| **Deploy**    | Push to Main     | Infrastructure Orchestration (Bicep) |
| **Build**     | Push/PR          | .NET 10 Compilation & Validation     |
| **AKS Stop**  | Schedule (20:00) | FinOps: Nightly Hibernation          |
| **AKS Start** | Schedule (09:00) | Environment Availability             |
| **PR Env**    | PR Activity      | Isolation & Feature Testing          |
