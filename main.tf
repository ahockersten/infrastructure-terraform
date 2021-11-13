terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  email = "anders@hockersten.se"
  api_token = var.cloudflare_api_token
}
