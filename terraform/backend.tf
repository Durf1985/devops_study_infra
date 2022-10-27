terraform {
 backend "gcs" {
   bucket  = "reddit-app-bucket-20221026"
   prefix  = "terraform/state"
 }
}
