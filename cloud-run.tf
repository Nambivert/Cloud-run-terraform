#Activate service APIs

resource "google_project_service" "run" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudbuild" {
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "secretmanager" {
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

# Create the secrets

resource "google_secret_manager_secret" "firealarm-slack-secret" {
  secret_id = "firealarm-slack-secret"

  replication {
    automatic = true
  }
  depends_on = [google_project_service.secretmanager]

}

resource "google_secret_manager_secret" "firealarm-webhook-url" {
  secret_id = "firealarm-webhook-url"

  replication {
    automatic = true
  }
  depends_on = [google_project_service.secretmanager]

}

resource "google_secret_manager_secret" "firealarm-routing-key" {
  secret_id = "firealarm-routing-key"

  replication {
    automatic = true
  }
  depends_on = [google_project_service.secretmanager]

}

resource "google_cloud_run_service" "service" {
  name                       = "firealarm-slash-command-terraform"
  project                    = var.project
  location                   = var.region
  autogenerate_revision_name = true

  template {
    spec {
      service_account_name = "firealarm-test@fiery-chess-357609.iam.gserviceaccount.com"
      containers {
        image = var.image

        resources {
          requests = {
            cpu    = "250m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "1000m"
            memory = "256Mi"
          }
        }

        env {
          name  = "FLASK-PORT"
          value = "8080"
        }
        env {
          name = "SLACK_SECRET"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.firealarm-slack-secret.secret_id
              key  = "1"
            }
          }
        }
        env {
          name = "WEBHOOK_URL"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.firealarm-webhook-url.secret_id
              key  = "1"
            }
          }
        }
        env {
          name = "ROUTING_KEY"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.firealarm-routing-key.secret_id
              key  = "1"
            }
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
