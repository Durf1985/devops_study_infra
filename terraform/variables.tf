variable "project" {
  type = string
  description = "Project ID"
  
}
variable "region" {
  type = string
  description = "Region"
  default = "us-central1"
}
variable "public_key_path" {
  type = string
  description = "Path to the public key used for ssh access"
  
}
variable "disk_image" {
  type = string
  description = "Disk image"
  
}
variable "private_key_path" {
  type = string
  description = "Path to private key which will be installed into project metadata"
  default = "~/.ssh/appuser"
}
variable "user_name" {
  type = set(string)
  description = "List of user names"
  default = [
    "appuser",
    "appuser1"
  ]
}
