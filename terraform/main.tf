terraform {
  required_version = "1.2.9"
  required_providers {
    google = {
      version = "4.0.0"
      }
  }
}
provider "google" {
  
  project = "clgcporg2-079"
  region = "us-central1"
}
resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "e2-medium"
  zone = "us-central1-a"
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
    ssh-key = "${file("~/github_repo/devops_study_infra/packer/scripts/TXT.pub")}"
  }
}
