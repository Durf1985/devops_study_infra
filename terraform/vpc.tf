resource "google_compute_firewall" "firewall_ssh" {
  name    = "allow-default-ssh-connect"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
