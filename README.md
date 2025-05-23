# Initial setup

## Adding a GitHub access token

Go to GitHub and create an access token for access to the all repos: https://github.com/settings/tokens

Give it access to:
```
Administration
  Access: Read and write
Contents
  Access: Read and write
Metadata
  Access: Read-only
Variables
  Access: Read and write
Secrets
  Access: Read and write
```

## Adding a Cloudflare access token for your account

Go to cloudflare's page, create an access token here: https://dash.cloudflare.com/profile/api-tokens

It will need access to the following:
```
  Anders@hockersten.se's Account
      All zones - DNS:Edit
```

## Adding terraform variables

Create a `terraform.tfvars`. It should contain:

```
cloudflare_api_token = "<secret_token>"
github_token = "<secret_token>"
```

## Creating a script for running terraform-backend-git

You need:
```
echo "export GIT_USERNAME=ahockersten" > terraform-backend-git.sh
echo "export GITHUB_TOKEN=<token created in previous step>" >> terraform-backend-git.sh
echo "terraform-backend-git" >> terraform-backend-git.sh
chmod +x terraform-backend-git.sh
```

# Running terraform

Run terraform-backend-git
```
./terraform-backend-git.sh
```

```
gcloud auth application-default login
terraform init
```

Now, we can apply the terraform config:

```
terraform plan --out tfplan
terraform apply tfplan
```

# How Vaultwarden was setup

Run:
```
gcloud auth application-default login
terraform apply -target module.vaultwarden.google_cloud_run_domain_mapping.vaultwarden
terraform apply
```

## Verify domain

Verify the applicable domain after Terraform has set it up: https://search.google.com/search-console/welcome?domain=hockersten.se

## Email support

Login to Brevo to get email credentials.

The automation will have created the secrets necessary, but you still need to go into the Secret Manager UI and fill them in:
https://console.cloud.google.com/security/secret-manager?invt=AbuoFg&project=vaultwarden-452515

## Enabling admin mode

The automation will have created the secrets necessary, but you still need to go into the Secret Manager UI and fill them in:
https://console.cloud.google.com/security/secret-manager?invt=AbuoFg&project=vaultwarden-452515

You also need to make sure ADMIN_TOKEN variable gets set. The code for this is currently commented out.

## Cloudflare hack 1

In order for Google to be able to do an ACME challenge, I needed to create a WAF rule for Cloudflare. Apparently their new terraform provider does not have this yet. Here is an export:

```
curl -X PATCH \
	"https://api.cloudflare.com/client/v4/zones/ddd94cf572a2dd3b97ece2a5ab86f8c1/rulesets/da8a379072a24ef0a2ee4fcdc514fecd/rules/57465443b314475f8efccac5a655c374" \
	-H "Authorization: Bearer $CF_AUTH_TOKEN" \
 -d '{
    "action": "skip",
    "action_parameters": {
        "phases": [
            "http_ratelimit",
            "http_request_sbfm",
            "http_request_firewall_managed"
        ],
        "products": [
            "zoneLockdown",
            "uaBlock",
            "bic",
            "hot",
            "securityLevel",
            "rateLimit",
            "waf"
        ],
        "ruleset": "current"
    },
    "description": "Allow ACME challenge",
    "enabled": true,
    "expression": "(http.request.uri.path wildcard r\"/.well-known/acme-challenge/*\")",
    "id": "57465443b314475f8efccac5a655c374",
    "last_updated": "2025-03-08T06:31:10.095645Z",
    "logging": {
        "enabled": true
    },
    "ref": "57465443b314475f8efccac5a655c374",
    "version": "1",
    "position": {
        "index": 1
    }
}'
```

## Cloudflare hack 2

I needed to change the SSL/TLS encryption from "automatic" to "full" after Google had issued the certificate. Then I could change it back again. Probably Cloudflare had sorted itself out if I had just waited?

# How git-it-done was setup

```
gcloud auth application-default login
terraform apply -target module.git-it-done.google_cloud_run_domain_mapping.git_it_done
terraform apply
```

You may need to do this multiple times.
