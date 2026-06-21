# infra/live/proxmox/providers.tf

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.84.0"
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
