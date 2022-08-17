locals {
 terraform_service_account = "firealarm-test@fiery-chess-357609.iam.gserviceaccount.com"
}

provider "google" {
 alias = "impersonation"
 project     = var.project
 region      = var.region
 scopes = [
   "https://www.googleapis.com/auth/cloud-platform",
   "https://www.googleapis.com/auth/userinfo.email",
 ]
}

data "google_service_account_access_token" "default" {
 provider               	= google.impersonation
 target_service_account 	= local.terraform_service_account
 scopes                 	= ["userinfo-email", "cloud-platform"]
 lifetime               	= "1200s"
}

provider "google" {
 access_token	     = data.google_service_account_access_token.default.access_token
 request_timeout 	 = "60s"
}
