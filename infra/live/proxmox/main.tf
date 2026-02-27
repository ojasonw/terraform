# infra/live/proxmox/main.tf
# Configuracao principal do ambiente proxmox

locals {
  user_data_path = "${path.module}/../../../modules/proxmox-vm/templates/user-data.yaml"

  images = {
    ubuntu_2204 = {
      type    = "cloud-image"
      file_id = "local:iso/jammy-server-cloudimg-amd64.img"
    }

    ubuntu_2404 = {
      type    = "cloud-image"
      file_id = "local:iso/noble-server-cloudimg-amd64.img"
    }

    windows_server_eval = {
      type          = "iso"
      iso_id        = "local:iso/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
      virtio_iso_id = "local:iso/virtio-win.iso"
    }
  }

  vms = {
    joga-together = {
      name         = "joga-together"
      os           = "ubuntu_2404"
      cpu_cores    = 1
      mem_mb       = 10240
      disk_size_gb = 10
    }

  }
}
# ========================================
# Proxmox VMs
# ========================================
module "proxmox_vms" {
  source = "../../../modules/proxmox-vm"

  node_name      = var.proxmox_node
  datastore      = var.proxmox_datastore
  bridge         = var.proxmox_bridge
  iso_storage    = var.proxmox_iso_storage
  cloud_image    = var.cloud_image
  user_data_file = local.user_data_path
  default_tags   = ["terraform", "managed", "proxmox"]

  images = local.images
  vms    = local.vms
}