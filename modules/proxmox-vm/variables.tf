# modules/proxmox-vm/variables.tf

variable "node_name" {
  description = "Nome do node Proxmox primario (padrao)"
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

variable "images" {
  description = "Catalogo de imagens/ISOs disponiveis"
  type = map(object({
    type          = string           # "cloud-image" ou "iso"
    file_id       = optional(string) # cloud-image
    iso_id        = optional(string) # ISO installer
    virtio_iso_id = optional(string) # Windows
  }))
}

variable "ssh_user_data_template" {
  description = "Template cloud-init para auth via chave SSH (opcional, usa o padrao do modulo se nulo)"
  type        = string
  default     = null
}

variable "password_user_data_template" {
  description = "Template cloud-init para auth via senha (opcional, usa o padrao do modulo se nulo)"
  type        = string
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
    name             = string
    os               = string
    node             = optional(string)           # override para criar no node B
    cpu_cores        = optional(number, 2)
    cpu_type         = optional(string, "x86-64-v2-AES")
    mem_mb           = optional(number, 2048)
    disk_size_gb     = optional(number, 50)
    bridge           = optional(string)
    datastore        = optional(string)
    ipv4_address     = optional(string, "dhcp")
    ipv4_gateway     = optional(string)
    tags             = optional(list(string))
    auth_mode        = optional(string, "ssh_key") # "ssh_key" ou "password"
    vm_password_hash = optional(string)            # hash SHA-512: openssl passwd -6 "senha"
  }))
}
