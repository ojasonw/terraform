# modules/proxmox-vm/main.tf
# Modulo reutilizavel para criar VMs no Proxmox

locals {
  vmid_offset = 10000

  systemframe_vmid_map = {
    for k, vm in var.vms :
    k => local.vmid_offset + (parseint(substr(md5(k), 0, 8), 16) % 90000)
  }

  resolved = {
    for k, vm in var.vms : k => var.images[vm.os]
  }

  auth_templates = {
    ssh_key  = coalesce(var.ssh_user_data_template, "${path.module}/templates/user-data-ssh.yaml.tpl")
    password = coalesce(var.password_user_data_template, "${path.module}/templates/user-data-password.yaml.tpl")
  }

  cloud_image_vms = {
    for k, vm in var.vms : k => vm
    if local.resolved[k].type == "cloud-image"
  }
}

resource "proxmox_virtual_environment_file" "user_data_snippet" {
  for_each = local.cloud_image_vms

  node_name    = coalesce(each.value.node, var.node_name)
  content_type = "snippets"
  datastore_id = var.iso_storage

  source_raw {
    data = templatefile(
      local.auth_templates[coalesce(each.value.auth_mode, "ssh_key")],
      { password_hash = each.value.vm_password_hash != null ? each.value.vm_password_hash : "" }
    )
    file_name = "user-data-${each.key}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.vms

  vm_id     = local.systemframe_vmid_map[each.key]
  name      = each.value.name
  node_name = coalesce(each.value.node, var.node_name)

  started = local.resolved[each.key].type == "cloud-image"

  dynamic "agent" {
    for_each = local.resolved[each.key].type == "iso" ? [1] : []
    content {
      enabled = false
      timeout = "3m"
    }
  }
  dynamic "agent" {
    for_each = local.resolved[each.key].type != "iso" ? [1] : []
    content {
      enabled = true
      timeout = "10m"
    }
  }

  cpu {
    cores = try(each.value.cpu_cores, 2)
    type  = try(each.value.cpu_type, "x86-64-v2-AES")
  }

  memory {
    dedicated = try(each.value.mem_mb, 2048)
  }

  dynamic "disk" {
    for_each = local.resolved[each.key].type == "cloud-image" ? [1] : []
    content {
      datastore_id = coalesce(each.value.datastore, var.datastore)
      size         = coalesce(each.value.disk_size_gb, 50)
      interface    = "scsi0"
      file_format  = "raw"
      file_id      = local.resolved[each.key].file_id
    }
  }
  dynamic "disk" {
    for_each = local.resolved[each.key].type == "iso" ? [1] : []
    content {
      datastore_id = coalesce(each.value.datastore, var.datastore)
      size         = coalesce(each.value.disk_size_gb, 50)
      interface    = "sata0" # SATA for Windows native support (no VirtIO drivers needed)
      file_format  = "raw"
    }
  }

  dynamic "network_device" {
    for_each = local.resolved[each.key].type == "iso" ? [1] : []
    content {
      model  = "e1000"
      bridge = try(each.value.bridge, var.bridge)
    }
  }
  dynamic "network_device" {
    for_each = local.resolved[each.key].type == "cloud-image" ? [1] : []
    content {
      model  = "virtio"
      bridge = try(each.value.bridge, var.bridge)
    }
  }

  dynamic "initialization" {
    for_each = local.resolved[each.key].type == "cloud-image" ? [1] : []
    content {
      datastore_id      = try(each.value.datastore, var.datastore)
      user_data_file_id = proxmox_virtual_environment_file.user_data_snippet[each.key].id

      ip_config {
        ipv4 {
          address = try(each.value.ipv4_address, "dhcp")
          gateway = try(each.value.ipv4_gateway, null)
        }
      }
    }
  }

  dynamic "cdrom" {
    for_each = local.resolved[each.key].type == "iso" ? [1] : []
    content {
      file_id = local.resolved[each.key].iso_id
    }
  }

  serial_device {
    device = "socket"
  }

  tags = try(each.value.tags, var.default_tags)

  lifecycle {
    ignore_changes = [
      initialization,
      started,
      cdrom,
    ]
  }
}
