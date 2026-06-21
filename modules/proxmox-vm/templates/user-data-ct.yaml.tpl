#cloud-config
users:
  - name: ubuntu
    gecos: "Ubuntu User"
    groups: [adm, sudo, docker]
    shell: /bin/bash
    lock_passwd: true
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
    - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKlEKs2k59Z0XU2F98mmLHNBrVCKyvtdtjb9BDA27uko
    - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCC0quiXbO1n+9U1mniMrMOPh9bt3H26/5BaUbHbr+6
    - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCVQtAb9abo2PZPpkkk3MyPCXK7GjZj3ZyZO5HawQVT

ssh_pwauth: false
disable_root: true

package_update: true
package_upgrade: false
packages:
  - qemu-guest-agent
  - curl
  - git
  - net-tools
  - htop
  - tmux
  - nano
  - unzip
  - ca-certificates
  - gnupg
  - lsb-release

chpasswd:
  expire: false

swap:
  filename: /swapfile
  size: 2G
  maxsize: 2G

runcmd:
  - install -m 0755 -d /etc/apt/keyrings
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  - chmod a+r /etc/apt/keyrings/docker.asc
  - echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" > /etc/apt/sources.list.d/docker.list
  - apt-get update -qq
  - apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  - systemctl enable --now docker
  - systemctl enable --now qemu-guest-agent

package_reboot_if_required: true

final_message: "Cloud-init finalizado apos $UPTIME segundos."
