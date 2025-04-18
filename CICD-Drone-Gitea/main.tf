provider "proxmox" {
  pm_api_url = "https://<proxmox-ip>:8006/api2/json"
  pm_user = "root@pam"
  pm_password = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "ci_vm" {
  name = "ci-server"
  target_node = "pve"
  clone = "ubuntu-cloudinit-template" # Nome do seu template com Cloud-Init
  cores = 2
  memory = 2048
  disk {
    size = "20G"
    type = "scsi"
    storage = "local-lvm"
  }
  ipconfig0 = "ip=dhcp"
  os_type = "cloud-init"
  cloudinit_cdrom_storage = "local-lvm"
  sshkeys = file("~/.ssh/id_rsa.pub")

  cicustom = "user=local:snippets/user-data.yaml"
}
