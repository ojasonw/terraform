# infra/live/proxmox/main.tf
# Configuracao principal do ambiente proxmox

locals {
  containers = {
    ci-proxy = {
      hostname         = "ci-proxy"
      template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
      cpu_cores        = 1
      mem_mb           = 512
      swap_mb          = 512
      disk_size_gb     = 8
      ipv4_address     = "192.168.15.200/24"
      ipv4_gateway     = "192.168.15.1"
      tags             = ["terraform", "managed", "ci", "proxy"]
    }
  }

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
      auth_mode    = "ssh_key"
      cpu_cores    = 1
      mem_mb       = 10240
      disk_size_gb = 10
    }

    homelab-dev = {
      name         = "homelab-dev"
      os           = "ubuntu_2404"
      auth_mode    = "ssh_key"
      cpu_cores    = 4
      mem_mb       = 6144
      disk_size_gb = 100
    }
  }
}

# ========================================
# LXC Containers
# ========================================
module "proxmox_lxc" {
  source = "../../../modules/proxmox-lxc"

  node_name    = var.proxmox_node
  datastore    = var.proxmox_datastore
  bridge       = var.proxmox_bridge
  default_tags = ["terraform", "managed", "proxmox"]

  ssh_public_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILmp4+eX/auAAKCP9if15Z3WPov8K5OzIqDbLdtDPOGn cicd_action_gh",
  ]

  containers = local.containers
}

# ========================================
# Proxmox VMs
# ========================================
module "proxmox_vms" {
  source = "../../../modules/proxmox-vm"

  node_name    = var.proxmox_node
  datastore    = var.proxmox_datastore
  bridge       = var.proxmox_bridge
  iso_storage  = var.proxmox_iso_storage
  default_tags = ["terraform", "managed", "proxmox"]

  ssh_user_data_template      = "${path.module}/../../../modules/proxmox-vm/templates/user-data-ssh.yaml.tpl"
  password_user_data_template = "${path.module}/../../../modules/proxmox-vm/templates/user-data-password.yaml.tpl"

  images = local.images
  vms    = local.vms
}
