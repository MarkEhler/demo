terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

# Resource Group
resource "azurerm_resource_group" "MarkEhler_demo" {
  name     = var.resource_group_name
  location = var.azure_region
  
  tags = {
    Environment = "Demo"
    Project     = "MarkEhler-Datadog"
    ManagedBy   = "Terraform"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "MarkEhler_demo" {
  name                = "${var.project_prefix}-vnet"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.MarkEhler_demo.location
  resource_group_name = azurerm_resource_group.MarkEhler_demo.name
}

# VM Subnet
resource "azurerm_subnet" "vm_subnet" {
  name                 = "${var.project_prefix}-vm-subnet"
  resource_group_name  = azurerm_resource_group.MarkEhler_demo.name
  virtual_network_name = azurerm_virtual_network.MarkEhler_demo.name
  address_prefixes     = [var.vm_subnet_cidr]
}

# AKS Subnet
resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.project_prefix}-aks-subnet"
  resource_group_name  = azurerm_resource_group.MarkEhler_demo.name
  virtual_network_name = azurerm_virtual_network.MarkEhler_demo.name
  address_prefixes     = [var.aks_subnet_cidr]
}

# Network Security Group for VM
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.project_prefix}-vm-nsg"
  location            = azurerm_resource_group.MarkEhler_demo.location
  resource_group_name = azurerm_resource_group.MarkEhler_demo.name

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "Tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "Demo"
  }
}

# Network Interface for VM
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.project_prefix}-vm-nic"
  location            = azurerm_resource_group.MarkEhler_demo.location
  resource_group_name = azurerm_resource_group.MarkEhler_demo.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

# Public IP for VM
resource "azurerm_public_ip" "vm_pip" {
  name                = "${var.project_prefix}-vm-pip"
  location            = azurerm_resource_group.MarkEhler_demo.location
  resource_group_name = azurerm_resource_group.MarkEhler_demo.name
  allocation_method   = "Static"
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "MarkEhler_demo_vm" {
  name                = "${var.project_prefix}-vm"
  location            = azurerm_resource_group.MarkEhler_demo.location
  resource_group_name = azurerm_resource_group.MarkEhler_demo.name
  size                = var.vm_size

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Environment = "Demo"
    DeploymentId = "datadog-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  }
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "MarkEhler_demo_aks" {
  name                = "${var.project_prefix}-aks"
  location            = azurerm_resource_group.MarkEhler_demo.location
  resource_group_name = azurerm_resource_group.MarkEhler_demo.name
  dns_prefix          = var.project_prefix

  default_node_pool {
    name           = "default"
    node_count     = var.aks_node_count
    vm_size        = var.vm_size
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    service_cidr      = var.aks_service_cidr
    dns_service_ip    = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
  }

  tags = {
    Environment = "Demo"
    DeploymentId = "datadog-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  }
}

# Store identifiers in Key Vault
resource "azurerm_key_vault" "MarkEhler_demo" {
  name                = "${var.project_prefix}kv${random_string.kv_suffix.result}"
  location            = azurerm_resource_group.MarkEhler_demo.location
  resource_group_name = azurerm_resource_group.MarkEhler_demo.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = ["Get", "List"]
    secret_permissions = ["Get", "List", "Set"]
  }
}

resource "azurerm_key_vault_secret" "vm_id" {
  name         = "vm-id"
  value        = azurerm_linux_virtual_machine.MarkEhler_demo_vm.id
  key_vault_id = azurerm_key_vault.MarkEhler_demo.id
}

resource "azurerm_key_vault_secret" "aks_cluster_id" {
  name         = "aks-cluster-id"
  value        = azurerm_kubernetes_cluster.MarkEhler_demo_aks.id
  key_vault_id = azurerm_key_vault.MarkEhler_demo.id
}

resource "azurerm_key_vault_secret" "kubeconfig" {
  name         = "kubeconfig"
  value        = azurerm_kubernetes_cluster.MarkEhler_demo_aks.kube_admin_config_raw
  key_vault_id = azurerm_key_vault.MarkEhler_demo.id
}

# Random suffix for Key Vault name uniqueness
resource "random_string" "kv_suffix" {
  length  = 4
  special = false
  upper   = false
}

# Data source for current Azure context
data "azurerm_client_config" "current" {}