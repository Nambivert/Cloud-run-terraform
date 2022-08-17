provider "google" {
  project     = var.project
  region      = var.region
  credentials = file("/nambi1744/firealarm-tf.json")
}
