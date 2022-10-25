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
module "storage-bucket" {
  source   = "SweetOps/storage-bucket/google"
  version  = "0.4.0"
  name     = "reddit-app-bucket-20221026"
  location = "us-central1"
  enabled  = true

}
output "storage-bucket_url" {
  value = module.storage-bucket.url
}
