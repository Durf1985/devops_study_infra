terraform {
  required_version = "1.2.9"
  required_providers {
    google = {
      version = "4.0.0"
    }
  }
}
provider "google" {

  project = "clgcporg2-094"
  region  = "us-central1"
}
resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  tags         = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = "reddit-base"
    }
  }
  network_interface {
    network = "default"
    access_config {

    }

  }
  metadata = {
    ssh-keys = "appuser:${file("packer/scripts/TXT.pub")}"
  }

  connection {
    host = google_compute_instance.app.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = file("~/.ssh/appuser")
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
