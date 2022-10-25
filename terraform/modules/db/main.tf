resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "e2-medium"
  zone         = var.zone

  tags         = ["reddit-db"]

  network_interface {
    network       = "default"
    access_config  {}
  }

  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = var.db_port
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
  
}
