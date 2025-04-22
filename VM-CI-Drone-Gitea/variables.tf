variable "pm_api_url" {
  type    = string
  default = "https://192.168.18.165:8006/api2/json"
}

variable "pm_api_token_id" {
  description = "Ex: terraform@pve!tf-token"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Token secret"
  type        = string
  sensitive   = true
}

variable "target_node" {
  description = "Proxmox node to deploy the container on"
  type        = string
}

variable "storage" {
  description = "Storage pool to use for container rootfs"
  type        = string
}

variable "ssh_key_path" {
  description = "Path to SSH public key to authorize in container"
  type        = string
}