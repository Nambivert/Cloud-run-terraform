terraform {
  backend "gcs" {
    bucket = "firealarm-slack-terraform-bucket"
    prefix = "firealarm-slack/state"
  }
}
