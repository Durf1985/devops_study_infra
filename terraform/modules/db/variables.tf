variable "db_disk_image" {
  type        = string
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
variable "public_key_path" {
  type        = string
  description = "Path to the public key used for ssh access"

}
variable "zone" {
  type        = string
  description = "Zone"
  default     = "us-central1-a"
}
variable "db_port" {
  type        = list(string)
  description = "DB port"
  default     = ["27017"]
}
