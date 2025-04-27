terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.0"
    }
  }
  backend "http" {
    address        = "http://localhost:6061/?type=git&ref=main&state=state.json&repository=https://github.com/ahockersten/tfstate.git"
    lock_address   = "http://localhost:6061/?type=git&ref=main&state=state.json&repository=https://github.com/ahockersten/tfstate.git"
    unlock_address = "http://localhost:6061/?type=git&ref=main&state=state.json&repository=https://github.com/ahockersten/tfstate.git"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}

provider "google" {
}

provider "google-beta" {
}

module "vaultwarden" {
  source = "./modules/vaultwarden"

  billing_account    = var.gcp_billing_account
  user_email         = var.user_email
  github_owner       = var.github_owner
  cloudflare_zone_id = cloudflare_zone.hockersten_se.id

  providers = {
    google      = google
    google-beta = google-beta
    github      = github
    cloudflare  = cloudflare
  }
}
