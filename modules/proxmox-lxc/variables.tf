# modules/proxmox-lxc/variables.tf

variable "node_name" {
  description = "Node Proxmox padrão"
  type        = string
}

variable "datastore" {
  description = "Datastore padrão para disco dos CTs"
  type        = string
  default     = "local-lvm"
}

variable "bridge" {
  description = "Bridge de rede padrão"
  type        = string
  default     = "vmbr0"
}

variable "ssh_public_keys" {
  description = "Chaves SSH públicas autorizadas nos CTs"
  type        = list(string)
  default     = []
}

variable "default_tags" {
  description = "Tags padrão para CTs"
  type        = list(string)
  default     = ["terraform", "managed"]
}

variable "lxc_templates" {
  description = "Catálogo de templates LXC disponíveis"
  type = map(object({
    file_id = string
    os_type = optional(string, "ubuntu")
  }))
}

variable "containers" {
  description = "Mapa de LXC containers para criar"
  type = map(object({
    hostname     = string
    template     = string
    node         = optional(string)
    cpu_cores    = optional(number, 1)
    mem_mb       = optional(number, 512)
    swap_mb      = optional(number, 512)
    disk_size_gb = optional(number, 8)
    datastore    = optional(string)
    bridge       = optional(string)
    ipv4_address = optional(string, "dhcp")
    ipv4_gateway = optional(string)
    tags         = optional(list(string))
  }))
}
