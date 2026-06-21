# infra/live/proxmox/outputs.tf

output "vm_ids" {
  description = "VMIDs das VMs criadas"
  value       = module.proxmox_vms.vm_ids
}

output "vm_names" {
  description = "Nomes das VMs criadas"
  value       = module.proxmox_vms.vm_names
}

output "vm_nodes" {
  description = "Nodes onde as VMs estao rodando"
  value       = module.proxmox_vms.vm_nodes
}

output "vm_ipv4_addresses" {
  description = "Enderecos IPv4 das VMs"
  value       = module.proxmox_vms.vm_ipv4_addresses
}

output "snippet_ids" {
  description = "IDs dos snippets cloud-init por VM"
  value       = module.proxmox_vms.snippet_ids
}

output "ct_ids" {
  description = "VMIDs dos LXC containers criados"
  value       = module.proxmox_lxc.ct_ids
}

output "ct_nodes" {
  description = "Nodes onde os CTs estao rodando"
  value       = module.proxmox_lxc.ct_nodes
}
