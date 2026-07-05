# infra/live/proxmox/providers.tf

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      # Pinned to a version confirmed working for VM disk import+resize.
      # >= 0.84.0 with no committed lock file let CI silently drift to
      # 0.111.1, which hits a known unfixed bug creating a new cloud-image
      # VM's boot disk: https://github.com/bpg/terraform-provider-proxmox/issues/2060
      version = "~> 0.86.0"
    }
  }

  backend "local" {
    path = "/opt/terraform/state/proxmox.tfstate"
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = var.proxmox_api_token
  insecure  = true # self-signed cert

  ssh {
    agent    = true
    username = "root"
    node {
      name    = var.proxmox_node
      address = var.proxmox_ssh_host
    }
    node {
      name    = var.proxmox_node_b
      address = var.proxmox_ssh_host_b
    }
  }
}
