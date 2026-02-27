# infra/live/home/variables.tf
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
  description = "Nome do node Proxmox"
  type        = string
  default     = "proxmox"
}

variable "proxmox_ssh_host" {
  description = "IP/hostname do Proxmox para SSH"
  type        = string
  default     = "192.168.15.199"
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

variable "cloud_image" {
  description = "ID da imagem cloud padrao"
  type        = string
  default     = "local:iso/jammy-server-cloudimg-amd64.img"
}

variable "vms" {
  type = map(object({
    systemframe_id = string
    name           = string
    vm_id          = optional(number)
    cpu_cores      = optional(number, 2)
    cpu_type       = optional(string, "x86-64-v2-AES")
    mem_mb         = optional(number, 2048)
    disk_size_gb   = optional(number, 50)
    bridge         = optional(string)
    datastore      = optional(string)
    file_id        = optional(string)
    vm_username    = optional(string)
    vm_password    = optional(string)
    ipv4_address   = optional(string, "dhcp")
    ipv4_gateway   = optional(string)
    tags           = optional(list(string))
  }))
  default = {}
}