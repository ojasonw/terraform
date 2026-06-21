#cloud-config
users:
  - name: systemframe
    gecos: "Ubuntu User"
    groups: [adm, sudo]
    shell: /bin/bash
    lock_passwd: false
    passwd: ${password_hash}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']

ssh_pwauth: true
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
