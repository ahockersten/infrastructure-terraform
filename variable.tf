variable "cloudflare_api_token" {
  description = "The API token to use for Cloudflare"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "The API token to use for GitHub"
  type        = string
  sensitive   = true
}
