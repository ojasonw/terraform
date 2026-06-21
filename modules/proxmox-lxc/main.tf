# modules/proxmox-lxc/main.tf
# Modulo reutilizavel para criar LXC containers no Proxmox

locals {
  vmid_offset = 20000

  ct_vmid_map = {
    for k, ct in var.containers :
    k => local.vmid_offset + (parseint(substr(md5(k), 0, 8), 16) % 70000)
  }
}

resource "proxmox_virtual_environment_container" "ct" {
  for_each = var.containers

  node_name    = coalesce(each.value.node, var.node_name)
  vm_id        = local.ct_vmid_map[each.key]
  unprivileged = each.value.unprivileged
  started      = true
  start_on_boot = true

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
    template_file_id = each.value.template_file_id
    type             = each.value.os_type
  }

  initialization {
    hostname = each.value.hostname

    dynamic "ip_config" {
      for_each = [1]
      content {
        ipv4 {
          address = each.value.ipv4_address
          gateway = each.value.ipv4_address != "dhcp" ? each.value.ipv4_gateway : null
        }
      }
    }

    user_account {
      keys = var.ssh_public_keys
    }
  }

  tags = try(each.value.tags, var.default_tags)
}
