variable "cloudflare_api_token" {
  description = "The API token to use for Cloudflare"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "The GitHub organization or user owner name."
  type        = string
  default     = "ahockersten" // Set your default owner name here
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
