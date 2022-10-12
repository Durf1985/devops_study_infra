terraform {
  required_version = "1.3.2"
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
  name         = "reddit-app-full"
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
      nat_ip = google_compute_address.app_ip.address // not an explicit dependency, the `app` resource will be created only after `app_ip`
    }
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
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

resource "google_compute_firewall" "firewall_ssh" {
  name="allow-default-ssh-connect"
  network = "default"
  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }
  source_ranges = [ "0.0.0.0/0" ]
}


resource "google_compute_project_metadata" "my_ssh_key" {
  metadata = {
    ssh-keys = join("\n", formatlist("%s:${chomp(file(var.public_key_path))}", var.user_name))
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
