#cloud-config
users:
  - name: ubuntu
    gecos: "Ubuntu User"
    groups: [adm, sudo]
    shell: /bin/bash
    lock_passwd: true
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
    - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKlEKs2k59Z0XU2F98mmLHNBrVCKyvtdtjb9BDA27uko

ssh_pwauth: false
disable_root: true

package_update: true
package_upgrade: false
packages:
  - qemu-guest-agent
  - tmux
  - nano
  - neofetch
  - curl
  - figlet
  - lsb-release
  - coreutils
  - git
  - htop
  - python3-pip
  - sshuttle
  - net-tools
  - wireguard

chpasswd:
  expire: false

swap:
  filename: /swapfile
  size: 4G
  maxsize: 4G

package_reboot_if_required: true

runcmd:
  - systemctl restart ssh
  - systemctl enable --now qemu-guest-agent

final_message: "Cloud-init finalizado apos $UPTIME segundos."
