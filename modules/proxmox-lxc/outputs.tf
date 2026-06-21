# modules/proxmox-lxc/outputs.tf

output "ct_ids" {
  description = "VMIDs dos CTs criados"
  value       = { for k, v in proxmox_virtual_environment_container.ct : k => v.id }
}

output "ct_names" {
  description = "Hostnames dos CTs"
  value       = { for k, v in proxmox_virtual_environment_container.ct : k => v.initialization[0].hostname }
}

output "ct_nodes" {
  description = "Nodes onde os CTs estao rodando"
  value       = { for k, v in proxmox_virtual_environment_container.ct : k => v.node_name }
}
