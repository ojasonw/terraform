# modules/proxmox-lxc/variables.tf

variable "node_name" {
  description = "Node Proxmox padrao"
  type        = string
}

variable "datastore" {
  description = "Datastore padrao para disco dos CTs"
  type        = string
  default     = "local-lvm"
}

variable "bridge" {
  description = "Bridge de rede padrao"
  type        = string
  default     = "vmbr0"
}

variable "ssh_public_keys" {
  description = "Chaves SSH publicas autorizadas nos CTs"
  type        = list(string)
  default     = []
}

variable "default_tags" {
  description = "Tags padrao para CTs"
  type        = list(string)
  default     = ["terraform", "managed"]
}

variable "containers" {
  description = "Mapa de LXC containers para criar"
  type = map(object({
    hostname     = string
    node         = optional(string)
    cpu_cores    = optional(number, 1)
    mem_mb       = optional(number, 512)
    swap_mb      = optional(number, 512)
    disk_size_gb = optional(number, 8)
    datastore    = optional(string)
    bridge       = optional(string)
    template_file_id = string
    os_type      = optional(string, "ubuntu")
    ipv4_address = optional(string, "dhcp") # "dhcp" ou "192.168.15.200/24"
    ipv4_gateway = optional(string)
    unprivileged = optional(bool, true)
    tags         = optional(list(string))
  }))
}
