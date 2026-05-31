# Infrastructure Deployment Module

## Overview
This module provisions the foundational Azure infrastructure for the Datadog deployment proof of concept. It creates both a Virtual Machine and an Azure Kubernetes Service (AKS) cluster, capturing all identifiers needed for subsequent Datadog agent deployment.

## Resources Generated

### 1. Azure Virtual Machine
- **Resource Type:** `azurerm_linux_virtual_machine`
- **SKU:** Standard_B2s (configurable)
- **Image:** Ubuntu 20.04 LTS
- **Purpose:** Host for Datadog VM agent deployment
- **Outputs:**
  - VM ID
  - VM Name
  - Private IP Address
  - Public IP Address (if applicable)
  - Resource Group Name

### 2. Azure Kubernetes Service (AKS) Cluster
- **Resource Type:** `azurerm_kubernetes_cluster`
- **Node Count:** 2 (configurable)
- **VM Size:** Standard_B2s per node
- **Kubernetes Version:** Latest stable
- **Purpose:** Kubernetes environment for Datadog cluster agent deployment
- **Outputs:**
  - Cluster Name
  - Cluster ID
  - Kube Config Content (base64 encoded)
  - Resource Group Name
  - API Server Address

### 3. Networking
- **Virtual Network:** Connects both resources
- **Subnets:** Dedicated subnets for VM and AKS
- **Network Security Group:** Controls ingress/egress for VM

### 4. Storage
- **Storage Account:** For VM diagnostics and logs
- **Keyvault Secrets:** Stores sensitive identifiers

## Output Values

All identifiers are exported via Terraform outputs and stored in a JSON artifact for Datadog deployment workflows:

```json
{
  "vm_id": "resource-id",
  "vm_name": "dti-demo-vm",
  "vm_private_ip": "10.0.1.x",
  "aks_cluster_id": "resource-id",
  "aks_cluster_name": "dti-demo-aks",
  "aks_api_server": "xxx.hcp.eastus.azmk8s.io",
  "resource_group": "dti-demo-rg",
  "kubeconfig_base64": "encoded-config"
}
```

## Deployment Flow

1. Terraform initializes and validates configuration
2. Resources are provisioned in Azure
3. Outputs are captured and stored as GitHub artifacts
4. Workflow trigger fires to initiate Datadog deployments
5. Datadog workflows consume the identifiers from artifacts

## Prerequisites

- Azure Subscription with appropriate permissions
- Terraform >= 1.0
- GitHub Secrets configured:
  - `AZURE_SUBSCRIPTION_ID`
  - `AZURE_CLIENT_ID`
  - `AZURE_CLIENT_SECRET`
  - `AZURE_TENANT_ID`