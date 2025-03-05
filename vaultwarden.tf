resource "google_cloud_run_v2_service" "vaultwarden" {
  name                = "vaultwarden"
  location            = "europe-north1"
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "docker.io/vaultwarden/server:latest-alpine"
      ports {
        container_port = 8080
      }
      resources {
        limits = {
          cpu    = "1"
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

resource "google_storage_bucket" "vaultwarden" {
  name     = "ahockersten-vaultwarden-data"
  location = "EUROPE-NORTH1"
}

resource "google_cloud_run_v2_service_iam_member" "noauth" {
  location = google_cloud_run_v2_service.vaultwarden.location
  name     = google_cloud_run_v2_service.vaultwarden.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_domain_mapping" "vaultwarden" {
  location = "europe-north1"
  name     = "hockersten.se"

  metadata {
    namespace = google_cloud_run_v2_service.vaultwarden.project
  }

  spec {
    route_name = google_cloud_run_v2_service.vaultwarden.name
  }
}

resource "cloudflare_dns_record" "google_site_verification" {
  name    = "_google-site-verification"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  # with https removed
  content = ""
  zone_id = cloudflare_zone.hockersten_se.id
}


resource "cloudflare_dns_record" "vaultwarden_hockersten_se" {
  name    = "vaultwarden"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  # with https removed
  content = replace(google_cloud_run_v2_service.vaultwarden.uri, "https://", "")
  zone_id = cloudflare_zone.hockersten_se.id
}
