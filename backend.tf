terraform {
  backend "gcs" {
    bucket = "firealarm-slack-terraform-bucket"
    prefix = "firealarm-slack/state"
    impersonate_service_account = "firealarm-test@fiery-chess-357609.iam.gserviceaccount.com"
  }
}
