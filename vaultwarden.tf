resource "google_project" "vaultwarden" {
  billing_account = "01601B-D26B44-151179"
  name            = "vaultwarden"
  project_id      = "vaultwarden-452515"
}

locals {
  location = "europe-north1"
  services = [
    "artifactregistry.googleapis.com",
    "cloudscheduler.googleapis.com",
    "iamcredentials.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
  ]

}

resource "google_project_service" "services" {
  for_each                   = toset(local.services)
  project                    = google_project.vaultwarden.project_id
  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = false
}

# This is used so the backup scheduled job is allowed to start the cloud run job
resource "google_service_account" "backup_job_service_account" {
  account_id   = "backup-job-service-account"
  display_name = "Vaultwarden Backup Job Service Account"
}

resource "google_project_iam_member" "cloudrun_job_executor" {
  project = google_project.vaultwarden.project_id
  role    = "roles/run.jobsExecutor"
  member  = "serviceAccount:${google_service_account.backup_job_service_account.email}"
}

# This is used so the cloud run job can access the secret manager
resource "google_service_account" "vaultwarden_service_account" {
  account_id   = "vaultwarden-service-account"
  display_name = "Vaultwarden Service Account"
}

resource "google_secret_manager_secret" "admin_token" {
  secret_id = "admin-token"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_iam_member" "secret_accessor_admin_token" {
  secret_id  = google_secret_manager_secret.admin_token.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.vaultwarden_service_account.email}"
  depends_on = [google_secret_manager_secret.admin_token]
}

resource "google_secret_manager_secret" "smtp_password" {
  secret_id = "smtp-password"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_iam_member" "secret_accessor_smtp_password" {
  secret_id  = google_secret_manager_secret.smtp_password.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.vaultwarden_service_account.email}"
  depends_on = [google_secret_manager_secret.smtp_password]
}

resource "google_cloud_run_v2_service" "vaultwarden" {
  provider             = google-beta
  name                 = "vaultwarden"
  location             = local.location
  deletion_protection  = false
  ingress              = "INGRESS_TRAFFIC_ALL"
  launch_stage         = "GA"
  default_uri_disabled = true

  template {
    containers {
      name  = "vaultwarden"
      image = "docker.io/vaultwarden/server:latest-alpine"
      ports {
        container_port = 8080
      }
      resources {
        cpu_idle = true

        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
      env {
        name  = "DOMAIN"
        value = "https://vaultwarden.hockersten.se"
      }
      env {
        name  = "ROCKET_PORT"
        value = "8080"
      }
      env {
        name  = "SIGNUPS_ALLOWED"
        value = "false"
      }
      env {
        name  = "SIGNUPS_DOMAINS_WHITELIST"
        value = "hockersten.se"
      }
      env {
        name  = "SMTP_HOST"
        value = "smtp-relay.brevo.com"
      }
      env {
        name  = "SMTP_PORT"
        value = "587"
      }
      env {
        name  = "SMTP_SECURITY"
        value = "starttls"
      }
      env {
        name  = "SMTP_FROM"
        value = "noreply@hockersten.se"
      }
      env {
        name  = "SMTP_USERNAME"
        value = "8a4855001@smtp-brevo.com"
      }
      env {
        name = "SMTP_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.smtp_password.secret_id
            version = "latest"
          }
        }
      }
      # enable this if you need access to the admin account for some reason
      #env {
      #  name = "ADMIN_TOKEN"
      #  value_source {
      #    secret_key_ref {
      #      secret  = google_secret_manager_secret.admin_token.secret_id
      #      version = "latest"
      #    }
      #  }
      #}
      volume_mounts {
        name       = "bucket"
        mount_path = "/data"
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 2
    }

    volumes {
      name = "bucket"
      gcs {
        bucket    = google_storage_bucket.vaultwarden.name
        read_only = false
      }
    }
    service_account = google_service_account.vaultwarden_service_account.email
  }
  depends_on = [
    google_artifact_registry_repository.docker_repo,
    google_project_service.services,
  ]

  lifecycle {
    ignore_changes = [
      // client gets changed whenever you do e.g. a manual deploy
      client,
    ]
  }
}

resource "google_cloud_run_v2_job" "vaultwarden_backup" {
  name                = "vaultwarden-backup-job"
  location            = local.location
  deletion_protection = false

  template {
    task_count = 1

    template {
      containers {
        image = "${google_artifact_registry_repository.docker_repo.location}-docker.pkg.dev/${google_artifact_registry_repository.docker_repo.project}/${google_artifact_registry_repository.docker_repo.repository_id}/vaultwarden-backup:latest"
        volume_mounts {
          name       = "bucket"
          mount_path = "/data"
        }
        volume_mounts {
          name       = "backup"
          mount_path = "/backup"
        }
      }

      volumes {
        name = "bucket"
        gcs {
          bucket    = google_storage_bucket.vaultwarden.name
          read_only = false
        }
      }
      volumes {
        name = "backup"
        gcs {
          bucket    = google_storage_bucket.vaultwarden_backup.name
          read_only = false
        }
      }
    }
  }

  depends_on = [
    google_artifact_registry_repository.docker_repo,
    google_project_service.services,
  ]
  lifecycle {
    ignore_changes = [
      // client gets changed whenever you do e.g. a manual deploy
      client,
    ]
  }
}

resource "google_cloud_scheduler_job" "vaultwarden_backup_job" {
  provider    = google-beta
  name        = "schedule-job"
  description = "Vaultwarden backup job"
  schedule    = "37 1 * * 0" # Run once a week at 01:37 on Sundays
  # TODO change to europe-north1 when available
  # https://cloud.google.com/scheduler/docs/locations
  region  = "europe-west1"
  project = google_project.vaultwarden.project_id

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.vaultwarden_backup.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${google_project.vaultwarden.project_id}/jobs/${google_cloud_run_v2_job.vaultwarden_backup.name}:run"

    oauth_token {
      service_account_email = google_service_account.backup_job_service_account.email
    }
  }
}

resource "google_storage_bucket" "vaultwarden" {
  name                     = "ahockersten-vaultwarden-data"
  location                 = local.location
  public_access_prevention = "enforced"
  lifecycle {
    prevent_destroy = true
  }
}

# let vaultwarden access its bucket
resource "google_storage_bucket_iam_member" "vaultwarden_access_vaultwarden" {
  bucket = google_storage_bucket.vaultwarden.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.vaultwarden_service_account.email}"
}

# let vaultwarden backup job access the vaultwarden bucket
resource "google_storage_bucket_iam_member" "backup_access_vaultwarden" {
  bucket = google_storage_bucket.vaultwarden.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.backup_job_service_account.email}"
}

# let vaultwarden backup job access the backup bucket
resource "google_storage_bucket_iam_member" "backup_access_backup" {
  bucket = google_storage_bucket.vaultwarden_backup.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.backup_job_service_account.email}"
}

resource "google_storage_bucket" "vaultwarden_backup" {
  name                     = "ahockersten-vaultwarden-backup"
  location                 = local.location
  public_access_prevention = "enforced"
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}


resource "google_cloud_run_v2_service_iam_member" "noauth" {
  location = google_cloud_run_v2_service.vaultwarden.location
  name     = google_cloud_run_v2_service.vaultwarden.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_domain_mapping" "vaultwarden" {
  location = google_cloud_run_v2_service.vaultwarden.location
  name     = "vaultwarden.hockersten.se"

  metadata {
    namespace = google_cloud_run_v2_service.vaultwarden.project
  }

  spec {
    route_name = google_cloud_run_v2_service.vaultwarden.name
  }
}

resource "cloudflare_dns_record" "vaultwarden_hockersten_se" {
  for_each = {
    for idx, record in google_cloud_run_domain_mapping.vaultwarden.status[0].resource_records :
    idx => record
  }

  name    = each.value.name != "" ? each.value.name : "vaultwarden"
  proxied = true
  ttl     = 1
  type    = each.value.type
  content = each.value.rrdata
  zone_id = cloudflare_zone.hockersten_se.id
}

resource "google_artifact_registry_repository" "docker_repo" {
  # provider      = google-beta # Uncomment if using the beta provider
  project       = google_project.vaultwarden.project_id
  location      = local.location
  repository_id = "vaultwarden"
  description   = "Docker repository for vaultwarden"
  format        = "DOCKER"

  cleanup_policies {
    id     = "keep-minimum-versions"
    action = "KEEP"
    most_recent_versions {
      keep_count = 3
    }
  }

  depends_on = [google_project_service.services["artifactregistry.googleapis.com"]]
}

resource "github_repository" "vaultwarden_backup" {
  name          = "vaultwarden-backup"
  description   = "A (very) simple container for doing Vaultwarden backups"
  has_downloads = true
  has_issues    = true
  has_projects  = true
  has_wiki      = true

  visibility = "public"
}

resource "github_actions_variable" "vaultwarden_backup_env_project_id" {
  repository    = github_repository.vaultwarden_backup.name
  variable_name = "GCP_PROJECT_ID"
  value         = google_project.vaultwarden.project_id
}

resource "github_actions_variable" "vaultwarden_backup_env_gar_location" {
  repository    = github_repository.vaultwarden_backup.name
  variable_name = "GAR_LOCATION"
  value         = local.location
}

resource "github_actions_variable" "vaultwarden_backup_env_gar_repository" {
  repository    = github_repository.vaultwarden_backup.name
  variable_name = "GAR_REPOSITORY"
  value         = google_artifact_registry_repository.docker_repo.repository_id
}

resource "github_actions_variable" "vaultwarden_backup_env_image_name" {
  repository    = github_repository.vaultwarden_backup.name
  variable_name = "IMAGE_NAME"
  value         = "vaultwarden-backup"
}

resource "github_actions_variable" "vaultwarden_backup_env_pool_id" {
  repository    = github_repository.vaultwarden_backup.name
  variable_name = "POOL_ID"
  value         = "github"
}

resource "github_actions_variable" "vaultwarden_backup_env_provider_id" {
  repository    = github_repository.vaultwarden_backup.name
  variable_name = "PROVIDER_ID"
  value         = "vaultwarden-backup"
}

resource "github_actions_variable" "vaultwarden_backup_env_cloud_run_service_name" {
  repository    = github_repository.vaultwarden_backup.name
  variable_name = "CLOUD_RUN_SERVICE_NAME"
  value         = google_cloud_run_v2_job.vaultwarden_backup.name
}

resource "github_actions_variable" "vaultwarden_backup_env_cloud_run_region" {
  repository    = github_repository.vaultwarden_backup.name
  variable_name = "CLOUD_RUN_REGION"
  value         = local.location
}
