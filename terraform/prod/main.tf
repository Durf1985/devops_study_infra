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

module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  zone            = var.zone
  app_disk_image  = var.app_disk_image
  db_address      = module.db.db_internal_ip
}
module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  zone            = var.zone
  db_disk_image   = var.db_disk_image
  
}
module "vpc" {
  source        = "../modules/vpc"
  source_ranges = var.source_ranges

}
resource "google_compute_project_metadata" "my_ssh_key" {
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}
