variable "project" {
  type        = string
  description = "Project ID"

}
variable "region" {
  type        = string
  description = "Region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Zone"
  default     = "us-central1-a"
}
variable "public_key_path" {
  type        = string
  description = "Path to the public key used for ssh access"

}
variable "disk_image" {
  type        = string
  description = "Disk image"

}
# variable "private_key_path" {
#   type        = string
#   description = "Path to private key which will be installed into project metadata"
#   default     = "~/.ssh/appuser"
# }
variable "user_name" {
  type        = set(string)
  description = "List of user names"
  default = [
    "appuser",
    "appuser1",
    "appuser_web"
  ]
}

variable "count_vm" {
  type        = number
  description = "Count of VM instance"
}

variable "source_image" {
  type        = string
  description = "Path to Baked VM image on GCP"
}

variable "app_disk_image" {
description = "Disk image for reddit app"
default = "reddit-app-base"
}

variable "db_disk_image" {
description = "Disk image for reddit db"
default = "reddit-db-base"
}
