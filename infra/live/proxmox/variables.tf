# infra/live/proxmox/variables.tf

variable "proxmox_api_url" {
  description = "URL da API do Proxmox"
  type        = string
}

variable "proxmox_api_token" {
  description = "Token de API do Proxmox (formato: user@realm!tokenid=secret)"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Nome do node Proxmox A (primario)"
  type        = string
  default     = "proxmox-a"
}

variable "proxmox_ssh_host" {
  description = "IP do node Proxmox A para SSH"
  type        = string
  default     = "192.168.15.199"
}

variable "proxmox_node_b" {
  description = "Nome do node Proxmox B"
  type        = string
  default     = "proxmox-b"
}

variable "proxmox_ssh_host_b" {
  description = "IP do node Proxmox B para SSH"
  type        = string
  default     = "192.168.15.198"
}

variable "proxmox_datastore" {
  description = "Datastore padrao para VMs"
  type        = string
  default     = "local-lvm"
}

variable "proxmox_bridge" {
  description = "Bridge de rede padrao"
  type        = string
  default     = "vmbr0"
}

variable "proxmox_iso_storage" {
  description = "Storage para ISOs e snippets"
  type        = string
  default     = "local"
}

variable "vm_password_hash" {
  description = "Hash SHA-512 para VMs com auth_mode=password. Gere com: openssl passwd -6 'senha'"
  type        = string
  sensitive   = true
  default     = ""
}
