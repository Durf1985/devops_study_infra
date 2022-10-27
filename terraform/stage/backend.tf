terraform {
 backend "gcs" {
   bucket  = "reddit-app-bucket"
   prefix  = "terraform/stage/state"
 }
}
