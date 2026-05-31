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
  default     = "10.0.0.0/16"
}

variable "vm_subnet_cidr" {
  type        = string
  description = "CIDR block for VM subnet"
  default     = "10.0.1.0/24"
}

variable "aks_subnet_cidr" {
  type        = string
  description = "CIDR block for AKS subnet"
  default     = "10.0.2.0/24"
}

variable "vm_size" {
  type        = string
  description = "VM size for both standalone VM and AKS nodes"
  default     = "Standard_B2s"
}

variable "aks_node_count" {
  type        = number
  description = "Number of nodes in AKS cluster"
  default     = 2
}

variable "aks_service_cidr" {
  type        = string
  description = "CIDR block for AKS services"
  default     = "10.1.0.0/16"
}

variable "aks_dns_service_ip" {
  type        = string
  description = "IP address for AKS DNS service"
  default     = "10.1.0.10"
}

variable "aks_docker_bridge_cidr" {
  type        = string
  description = "CIDR block for Docker bridge"
  default     = "172.17.0.1/16"
}

variable "admin_username" {
  type        = string
  description = "Admin username for VM"
  default     = "azureuser"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for VM authentication"
  sensitive   = true
  default     = "null"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed for SSH access"
  default     = "0.0.0.0/0"
}