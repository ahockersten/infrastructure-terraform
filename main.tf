terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
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

provider "google" {
  project = "vaultwarden-452515"
}
