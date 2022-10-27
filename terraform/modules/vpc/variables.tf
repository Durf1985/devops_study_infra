variable "source_ranges" {
  type = list(string)
  description = "Allowed IP addresses"
  default = ["0.0.0.0/0"]
}
