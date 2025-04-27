
variable "cloudflare_api_token" {
  description = "The API token to use for Cloudflare"
  type        = string
  sensitive   = true
}

variable "gcp_billing_account" {
  description = "The billing account ID to use for GCP"
  type        = string
  default     = "01601B-D26B44-151179"
}

variable "github_owner" {
  description = "The GitHub organization or user owner name."
  type        = string
  default     = "ahockersten"
}

variable "github_token" {
  description = "The API token to use for GitHub"
  type        = string
  sensitive   = true
}

variable "user_email" {
  description = "The email address of the user managing Terraform"
  type        = string
  default     = "anders.hockersten@gmail.com"
}
