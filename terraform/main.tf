terraform {
  required_version = "1.2.9"
  required_providers {
    google = {
      version = "4.0.0"
    }
  }
}
provider "google" {

  project = var.project
  region  = var.region
}
resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  tags         = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }
  network_interface {
    network = "default"
    access_config {

    }

  }
  metadata = {
    ssh-keys = "appuser:${file("${var.public_key_path}")}"
  }

  connection {
    host        = google_compute_instance.app.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = var.private_key_path
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}


resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]

}

resource "google_compute_project_metadata" "my_ssh_key" {
  for_each = var.user_name
  
  metadata = {
    ssh-keys = "${each.value}:${file("${var.public_key_path}")}"

  }
}
