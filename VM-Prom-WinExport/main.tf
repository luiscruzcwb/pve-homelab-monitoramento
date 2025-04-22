terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
}

resource "proxmox_lxc" "prom_winexport" {
  target_node  = var.target_node
  hostname     = var.hostname
  ostemplate   = "local:vztmpl/ubuntu-24.10-standard_24.10-1_amd64.tar.zst"
  password     = "admin123"
  unprivileged = true
  cores        = 2
  memory       = 2048
  swap         = 512
  start        = true
  onboot       = true

  rootfs {
    storage = var.storage
    size    = "10G"
  }

  ssh_public_keys = file(var.ssh_key_path)

  features {
    nesting = true
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.18.152/24"
    gw     = "192.168.18.1"
  }
}

resource "null_resource" "wait_for_ssh" {
  depends_on = [proxmox_lxc.prom_winexport]

  provisioner "local-exec" {
    command = "echo '[WAIT] Aguardando SSH da VM...' && timeout 300 bash -c 'until nc -z 192.168.18.152 22; do sleep 5; done'"
  }
}

resource "null_resource" "run_ansible_playbook" {
  depends_on = [null_resource.wait_for_ssh]

  provisioner "local-exec" {
    command = "bash ./scripts/run_ansible.sh"
  }
}
