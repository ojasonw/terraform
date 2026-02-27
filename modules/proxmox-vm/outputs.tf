# modules/proxmox-vm/outputs.tf

output "vm_ids" {
  description = "VMIDs por chave do mapa"
  value       = { for k, v in proxmox_virtual_environment_vm.vm : k => v.id }
}

output "vm_names" {
  description = "Nomes das VMs por chave"
  value       = { for k, v in proxmox_virtual_environment_vm.vm : k => v.name }
}

output "vm_nodes" {
  description = "Nodes onde as VMs estao rodando"
  value       = { for k, v in proxmox_virtual_environment_vm.vm : k => v.node_name }
}

output "vm_ipv4_addresses" {
  description = "Enderecos IPv4 das VMs (se disponiveis)"
  value       = { for k, v in proxmox_virtual_environment_vm.vm : k => try(v.ipv4_addresses, []) }
}

output "snippet_id" {
  description = "ID do snippet cloud-init"
  value       = var.user_data_file != null ? proxmox_virtual_environment_file.user_data_snippet[0].id : null
}
