output "resource_group_name" {
  value       = azurerm_resource_group.MarkEhler_demo.name
  description = "Name of the resource group"
}

output "vm_id" {
  value       = azurerm_linux_virtual_machine.MarkEhler_demo_vm.id
  description = "Resource ID of the VM"
}

output "vm_name" {
  value       = azurerm_linux_virtual_machine.MarkEhler_demo_vm.name
  description = "Name of the VM"
}

output "vm_private_ip" {
  value       = azurerm_network_interface.vm_nic.private_ip_address
  description = "Private IP address of the VM"
}

output "vm_public_ip" {
  value       = azurerm_public_ip.vm_pip.ip_address
  description = "Public IP address of the VM"
}

output "aks_cluster_id" {
  value       = azurerm_kubernetes_cluster.MarkEhler_demo_aks.id
  description = "Resource ID of the AKS cluster"
}

output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.MarkEhler_demo_aks.name
  description = "Name of the AKS cluster"
}

output "aks_api_server" {
  value       = azurerm_kubernetes_cluster.MarkEhler_demo_aks.fqdn
  description = "FQDN of the AKS API server"
}

output "kubeconfig_base64" {
  value       = base64encode(azurerm_kubernetes_cluster.MarkEhler_demo_aks.kube_admin_config_raw)
  sensitive   = true
  description = "Base64 encoded kubeconfig for AKS"
}

output "infrastructure_identifiers_json" {
  value = jsonencode({
    vm_id              = azurerm_linux_virtual_machine.MarkEhler_demo_vm.id
    vm_name            = azurerm_linux_virtual_machine.MarkEhler_demo_vm.name
    vm_private_ip      = azurerm_network_interface.vm_nic.private_ip_address
    vm_public_ip       = azurerm_public_ip.vm_pip.ip_address
    aks_cluster_id     = azurerm_kubernetes_cluster.MarkEhler_demo_aks.id
    aks_cluster_name   = azurerm_kubernetes_cluster.MarkEhler_demo_aks.name
    aks_api_server     = azurerm_kubernetes_cluster.MarkEhler_demo_aks.fqdn
    resource_group     = azurerm_resource_group.MarkEhler_demo.name
    deployment_id      = "datadog-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  })
  description = "Complete identifiers JSON for Datadog deployment workflows"
}