variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
  default     = "MarkEhler-demo-rg"
}

variable "azure_region" {
  type        = string
  description = "Azure region for deployment"
  default     = "eastus"
}

variable "project_prefix" {
  type        = string
  description = "Prefix for all resource names"
  default     = "MarkEhler-demo"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR block for virtual network"
  default     = "10.0.0.0/24"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for subnet (VM and AKS)"
  default     = "10.0.0.0/25"
}

variable "vm_size" {
  type        = string
  description = "VM size for both standalone VM and AKS nodes"
  default     = "Standard_DC2s_v3"
}

variable "aks_node_count" {
  type        = number
  description = "Number of nodes in AKS cluster"
  default     = 1
}

variable "aks_service_cidr" {
  type        = string
  description = "CIDR block for AKS services"
  default     = "10.1.0.0/24"
}

variable "aks_dns_service_ip" {
  type        = string
  description = "IP address for AKS DNS service"
  default     = "10.1.0.10"
}

variable "admin_username" {
  type        = string
  description = "Admin username for VM"
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Admin password for VM"
  default     = "Markwins1"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed for SSH access"
  default     = "0.0.0.0/0"
}