output "app_external_ip" {
  description = "Reddit app VM external IP"
  value       = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
}
output "app_internal_ip" {
  description = "Reddit app VM internal IP"
  value = google_compute_instance.app.network_interface[0].network_ip
}
