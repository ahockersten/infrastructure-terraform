data "google_project" "project" {}

resource "google_service_account" "vaultwarden_service_account" {
  account_id   = "vault-warden-service-account"
  display_name = "Vaultwarden Service Account"
}

resource "google_project_iam_member" "cloudrun_job_executor" {
  project = data.google_project.project.project_id
  role    = "roles/run.jobsExecutor"
  member  = "serviceAccount:${google_service_account.vaultwarden_service_account.email}"
}

resource "google_cloud_run_v2_service" "vaultwarden" {
  provider             = google-beta
  name                 = "vaultwarden"
  location             = "europe-north1"
  deletion_protection  = false
  ingress              = "INGRESS_TRAFFIC_ALL"
  launch_stage         = "BETA"
  default_uri_disabled = true

  template {
    containers {
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
      volume_mounts {
        name       = "bucket"
        mount_path = "/data"
      }
    }

    volumes {
      name = "bucket"
      gcs {
        bucket    = google_storage_bucket.vaultwarden.name
        read_only = false
      }
    }
  }
}

resource "google_cloud_run_v2_job" "vaultwarden_backup" {
  name                = "vaultwarden-backup-job"
  location            = "europe-north1"
  deletion_protection = false

  template {
    task_count = 1

    template {
      containers {
        image = "docker.io/ahockersten/vaultwarden-backup:latest"

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
}

resource "google_cloud_scheduler_job" "vaultwarden_backup_job" {
  provider    = google-beta
  name        = "schedule-job"
  description = "Vaultwarden backup job"
  schedule    = "37 1 * * 0" # Run once a week at 01:37 on Sundays
  # TODO change to europe-north1 when available
  # https://cloud.google.com/scheduler/docs/locations
  region  = "europe-west1"
  project = data.google_project.project.project_id

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.vaultwarden_backup.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.project.project_id}/jobs/${google_cloud_run_v2_job.vaultwarden_backup.name}:run"

    oauth_token {
      service_account_email = google_service_account.vaultwarden_service_account.email
    }
  }
}

resource "google_storage_bucket" "vaultwarden" {
  name     = "ahockersten-vaultwarden-data"
  location = "EUROPE-NORTH1"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket" "vaultwarden_backup" {
  name     = "ahockersten-vaultwarden-backup"
  location = "EUROPE-NORTH1"
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
