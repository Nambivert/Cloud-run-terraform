locals {
 terraform_service_account = "firealarm-test@fiery-chess-357609.iam.gserviceaccount.com"
}

provider "google" {
  alias = "tokengen"
}
# get config of the client that runs
data "google_client_config" "default" {
  provider = google.tokengen

}
data "google_service_account_access_token" "sa" {
  provider               = google.tokengen
  target_service_account = locals.terraform_service_account
  lifetime               = "600s"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

/******************************************
  GA Provider configuration
 *****************************************/
provider "google" {
  access_token = data.google_service_account_access_token.sa.access_token
  project      = var.project
}
