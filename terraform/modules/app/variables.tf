variable "zone" {
  type        = string
  description = "Zone"
  default     = "us-central1-a"
}
variable "app_disk_image" {
  type        = string
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable "public_key_path" {
  type        = string
  description = "Path to the public key used for ssh access"
}

variable "app_provision_enabled" {
  type        = bool
  description = "Provision switch"
  default     = true
}

variable "db_address" {
  type        = string
  description = "IP address VM with data base"
  default     = "localhost"
}
variable "app_port" {
  type    = list(string)
  default = ["9292"]
}
variable "private_key_path" {
  type        = string
  description = "Path to private key which will be installed into project metadata"
  default     = "~/.ssh/appuser"
}
