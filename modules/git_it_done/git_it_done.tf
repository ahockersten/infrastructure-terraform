resource "google_project" "git_it_done" {
  billing_account = var.billing_account
  name            = "git-it-done"
  project_id      = "git-it-done-452515"
}

locals {
  location = var.location
  services = [
    "artifactregistry.googleapis.com",
    "cloudscheduler.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
  ]
}

resource "google_project_service" "services" {
  for_each                   = toset(local.services)
  project                    = google_project.git_it_done.project_id
  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = false
}

# This is used so the cloud run job can access the secret manager
resource "google_service_account" "git_it_done_service_account" {
  project      = google_project.git_it_done.project_id
  account_id   = "git-it-done-service-account"
  display_name = "git it done Service Account"
}

resource "google_cloud_run_v2_service" "git_it_done" {
  provider             = google-beta
  project              = google_project.git_it_done.project_id
  name                 = "git-it-done"
  location             = local.location
  deletion_protection  = false
  ingress              = "INGRESS_TRAFFIC_ALL"
  launch_stage         = "GA"
  default_uri_disabled = true

  template {
    containers {
      name  = "git-it-done"
      image = "${google_artifact_registry_repository.docker_repo.location}-docker.pkg.dev/${google_artifact_registry_repository.docker_repo.project}/${google_artifact_registry_repository.docker_repo.repository_id}/git-it-done:latest"
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
        value = "https://git_it_done.hockersten.se"
      }
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
        bucket    = google_storage_bucket.git_it_done.name
        read_only = false
      }
    }
    service_account = google_service_account.git_it_done_service_account.email
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

resource "google_storage_bucket" "git_it_done" {
  project                  = google_project.git_it_done.project_id
  name                     = "ahockersten-git-it-done-data"
  location                 = local.location
  public_access_prevention = "enforced"
  lifecycle {
    prevent_destroy = true
  }
}

# let git_it_done access its bucket
resource "google_storage_bucket_iam_member" "git_it_done_access_git_it_done" {
  bucket = google_storage_bucket.git_it_done.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.git_it_done_service_account.email}"
}

resource "google_cloud_run_v2_service_iam_member" "noauth" {
  provider = google-beta
  project  = google_project.git_it_done.project_id
  location = google_cloud_run_v2_service.git_it_done.location
  name     = google_cloud_run_v2_service.git_it_done.name
  role     = "roles/run.invoker"
  member   = "user:${var.user_email}"
}

resource "google_cloud_run_domain_mapping" "git_it_done" {
  provider = google-beta
  project  = google_project.git_it_done.project_id
  location = google_cloud_run_v2_service.git_it_done.location
  name     = "git-it-done.hockersten.se"

  metadata {
    namespace = google_project.git_it_done.project_id
  }

  spec {
    route_name = google_cloud_run_v2_service.git_it_done.name
  }
}

resource "cloudflare_dns_record" "git_it_done_hockersten_se" {
  for_each = {
    for idx, record in google_cloud_run_domain_mapping.git_it_done.status[0].resource_records :
    idx => record
  }

  name    = each.value.name != "" ? each.value.name : "git-it-done"
  proxied = true
  ttl     = 1
  type    = each.value.type
  content = each.value.rrdata
  zone_id = var.cloudflare_zone_id
}

resource "google_artifact_registry_repository" "docker_repo" {
  provider      = google-beta
  project       = google_project.git_it_done.project_id
  location      = local.location
  repository_id = "git-it-done"
  description   = "Docker repository for git it done"
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

resource "github_repository" "git_it_done" {
  name          = "git-it-done"
  description   = "A simple web editor for git repositories"
  has_downloads = true
  has_issues    = true
  has_projects  = true
  has_wiki      = true

  visibility = "public"
}

resource "github_actions_variable" "git_it_done_env_project_id" {
  repository    = github_repository.git_it_done.name
  variable_name = "GCP_PROJECT_ID"
  value         = google_project.git_it_done.project_id
}

resource "github_actions_variable" "git_it_done_env_gar_location" {
  repository    = github_repository.git_it_done.name
  variable_name = "GAR_LOCATION"
  value         = local.location
}

resource "github_actions_variable" "git_it_done_env_gar_repository" {
  repository    = github_repository.git_it_done.name
  variable_name = "GAR_REPOSITORY"
  value         = google_artifact_registry_repository.docker_repo.repository_id
}

resource "github_actions_variable" "git_it_done_env_image_name" {
  repository    = github_repository.git_it_done.name
  variable_name = "IMAGE_NAME"
  value         = "git_it_done-backup"
}

resource "github_actions_variable" "git_it_done_env_pool_id" {
  repository    = github_repository.git_it_done.name
  variable_name = "POOL_ID"
  value         = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
}

resource "github_actions_variable" "git_it_done_env_provider_id" {
  repository    = github_repository.git_it_done.name
  variable_name = "PROVIDER_ID"
  value         = google_iam_workload_identity_pool_provider.github_provider.workload_identity_pool_provider_id
}

resource "github_actions_variable" "git_it_done_env_cloud_run_service_name" {
  repository    = github_repository.git_it_done.name
  variable_name = "CLOUD_RUN_SERVICE_NAME"
  value         = google_cloud_run_v2_service.git_it_done.name
}

resource "github_actions_variable" "git_it_done_env_cloud_run_region" {
  repository    = github_repository.git_it_done.name
  variable_name = "CLOUD_RUN_REGION"
  value         = local.location
}

resource "google_project_iam_member" "user_sa_token_creator" {
  project = google_project.git_it_done.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "user:${var.user_email}"
}

resource "google_project_iam_member" "user_wi_pool_admin" {
  project = google_project.git_it_done.project_id
  role    = "roles/iam.workloadIdentityPoolAdmin"
  member  = "user:${var.user_email}"
}

# Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = google_project.git_it_done.project_id
  workload_identity_pool_id = "github"
  display_name              = "GitHub Actions Pool"
  description               = "Workload Identity Pool for GitHub Actions"
  depends_on = [
    google_project_service.services["iam.googleapis.com"] // Ensure IAM API is enabled
  ]
}

# Workload Identity Pool Provider for the specific repo
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = google_project.git_it_done.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = github_repository.git_it_done.name
  display_name                       = github_repository.git_it_done.name
  description                        = "OIDC Provider for ${var.github_owner}/${github_repository.git_it_done.name}" # Use the input variable
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  attribute_condition = "assertion.repository_owner == '${var.github_owner}'"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  depends_on = [google_iam_workload_identity_pool.github_pool]
}

# IAM binding for GitHub Actions to write to Artifact Registry
resource "google_project_iam_member" "github_actions_artifact_writer" {
  project = google_project.git_it_done.project_id
  role    = "roles/artifactregistry.writer"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_owner}/${github_repository.git_it_done.name}" # Use the input variable
  depends_on = [
    google_iam_workload_identity_pool_provider.github_provider,
    google_project_service.services["artifactregistry.googleapis.com"]
  ]
}

resource "google_project_iam_member" "github_actions_run_developer" {
  project = google_project.git_it_done.project_id
  role    = "roles/run.developer"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_owner}/${github_repository.git_it_done.name}"
  depends_on = [
    google_iam_workload_identity_pool_provider.github_provider,
    google_project_service.services["run.googleapis.com"]
  ]
}

resource "google_service_account_iam_member" "github_actions_sa_user" {
  service_account_id = "projects/${google_project.git_it_done.project_id}/serviceAccounts/${google_project.git_it_done.number}-compute@developer.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/subject/repo:${var.github_owner}/${github_repository.git_it_done.name}:ref:refs/heads/main"
  depends_on = [
    google_iam_workload_identity_pool_provider.github_provider,
  ]
}
