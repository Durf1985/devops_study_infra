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
resource "google_compute_project_metadata" "my_ssh_key" {
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

}
