# modules/proxmox-vm/variables.tf

variable "node_name" {
  description = "Nome do node Proxmox"
  type        = string
}

variable "datastore" {
  description = "Datastore padrao para discos das VMs"
  type        = string
  default     = "local-lvm"
}

variable "bridge" {
  description = "Bridge de rede padrao"
  type        = string
  default     = "vmbr0"
}

variable "iso_storage" {
  description = "Storage para ISOs e snippets"
  type        = string
  default     = "local"
}

variable "cloud_image" {
  description = "ID da imagem cloud padrao"
  type        = string
  default     = "local:iso/jammy-server-cloudimg-amd64.img"
}
variable "images" {
  description = "Catálogo de imagens/ISOs disponíveis"
  type = map(object({
    type          = string           # "cloud-image" ou "iso"
    file_id       = optional(string) # cloud-image
    iso_id        = optional(string) # ISO installer
    virtio_iso_id = optional(string) # Windows
  }))
}
variable "user_data_file" {
  description = "Caminho para arquivo cloud-init user-data (opcional)"
  type        = string
  default     = null
}

variable "default_username" {
  description = "Username padrao para VMs"
  type        = string
  default     = "ubuntu"
}

variable "default_password" {
  description = "Senha padrao para VMs"
  type        = string
  sensitive   = true
  default     = null
}

variable "default_tags" {
  description = "Tags padrao para VMs"
  type        = list(string)
  default     = ["terraform", "managed"]
}

variable "vms" {
  description = "Mapa de VMs para criar"
  type = map(object({
    name         = string
    vm_id        = optional(number)
    os           = string
    cpu_cores    = optional(number, 2)
    cpu_type     = optional(string, "x86-64-v2-AES")
    mem_mb       = optional(number, 2048)
    disk_size_gb = optional(number, 50)
    bridge       = optional(string)
    datastore    = optional(string)
    file_id      = optional(string)
    vm_username  = optional(string)
    vm_password  = optional(string)
    ipv4_address = optional(string, "dhcp")
    ipv4_gateway = optional(string)
    tags         = optional(list(string))
  }))
}
