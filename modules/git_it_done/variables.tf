variable "billing_account" {
  description = "The GCP billing account ID."
  type        = string
}

variable "location" {
  description = "The GCP region to deploy resources in."
  type        = string
  default     = "europe-north1"
}

variable "user_email" {
  description = "The email address of the user managing Terraform."
  type        = string
}

variable "github_owner" {
  description = "The GitHub organization or user owner name."
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare Zone ID for hockersten.se."
  type        = string
}
