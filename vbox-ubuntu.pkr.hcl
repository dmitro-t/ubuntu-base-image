packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "ssh_pub_key" {
    type = string
}
variable "ssh_priv_key_file" {
    type = string
}
variable "user_password_hash" {
  type    = string
}
source "virtualbox-iso" "ubuntu" {
  guest_os_type = "Ubuntu_64"
  iso_url      = "https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso"
  iso_checksum = "file:https://releases.ubuntu.com/jammy/SHA256SUMS"

  output_directory = "output"
  shutdown_command = "echo 'ubuntu' | sudo -S shutdown -P now"

  ssh_username = "ubuntu"
  ssh_private_key_file = var.ssh_priv_key_file
  ssh_timeout = "2h"
  ssh_wait_timeout = "10000s"
  ssh_handshake_attempts = 200
  ssh_pty = true
  ssh_clear_authorized_keys = true #!

  cpus = 2
  memory = 2048
  disk_size = 20480

  #http_directory = "http"
  http_content = {
    "/user-data" = templatefile("${path.root}/http/user-data.pkrtpl.hcl", { 
      ssh_pub_key = var.ssh_pub_key 
      user_password_hash = var.user_password_hash 
    })
    "/meta-data" = ""
  }

  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
    "<enter>",
    "initrd /casper/initrd",
    "<enter>",
    "boot",
    "<enter>"
  ]

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--acpi", "on"], 
    ["modifyvm", "{{.Name}}", "--ioapic", "on"]
  ]
}

build {
  sources = ["source.virtualbox-iso.ubuntu"]
  provisioner "shell" {
    pause_before = "10s"
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "sudo apt-get update",
      "sudo -E apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade",
      "sudo -E apt-get install -y virtualbox-guest-utils"
    ]
  }  
}