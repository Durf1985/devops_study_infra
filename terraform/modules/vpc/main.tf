resource "google_compute_firewall" "firewall_ssh" {
  name    = "allow-default-ssh-connect"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = var.source_ranges
}

resource "google_compute_firewall" "jdauphant_nginx" {
  name    = "allow-nginx-connect"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = var.source_ranges
}
