# modules/proxmox-lxc/main.tf

locals {
  vmid_offset = 20000

  ct_vmid_map = {
    for k, ct in var.containers :
    k => local.vmid_offset + (parseint(substr(md5(k), 0, 8), 16) % 70000)
  }

  resolved = {
    for k, ct in var.containers :
    k => merge(ct, {
      template_file_id = var.lxc_templates[ct.template].file_id
      os_type          = var.lxc_templates[ct.template].os_type
    })
  }
}

resource "proxmox_virtual_environment_container" "ct" {
  for_each = var.containers

  node_name     = coalesce(each.value.node, var.node_name)
  vm_id         = local.ct_vmid_map[each.key]
  unprivileged  = true
  started       = true
  start_on_boot = true

  tags = coalesce(each.value.tags, var.default_tags)

  cpu {
    cores = each.value.cpu_cores
  }

  memory {
    dedicated = each.value.mem_mb
    swap      = each.value.swap_mb
  }

  disk {
    datastore_id = coalesce(each.value.datastore, var.datastore)
    size         = each.value.disk_size_gb
  }

  network_interface {
    name   = "eth0"
    bridge = coalesce(each.value.bridge, var.bridge)
  }

  operating_system {
    template_file_id = local.resolved[each.key].template_file_id
    type             = local.resolved[each.key].os_type
  }

  initialization {
    hostname = each.value.hostname

    ip_config {
      ipv4 {
        address = each.value.ipv4_address
        gateway = each.value.ipv4_address != "dhcp" ? each.value.ipv4_gateway : null
      }
    }

    user_account {
      keys = var.ssh_public_keys
    }
  }
}
