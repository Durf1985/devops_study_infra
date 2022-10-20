terraform {
 backend "gcs" {
   bucket  = "reddit-app-bucket"
   prefix  = "terraform/state"
 }
}
