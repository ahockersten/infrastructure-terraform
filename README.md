# Initial setup

## Installing prerequisites

## Adding a GitHub access token

Go to GitHub and create an access token for access to the `ahockersten/tfstate` repo: https://github.com/settings/tokens

It should be enough to give it access to:
```
Contents
  Access: Read and write
Metadata
  Access: Read-only
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
terraform init
```

Now, we can apply the terraform config:

```
terraform plan --out tfplan
terraform apply tfplan
```

# How Vaultwarden was setup

First, I created a project in the Google console named `vaultwarden`. In my case it got named `vaultwarden-452515`.

Enable Cloud Run API for it: https://console.cloud.google.com/apis/library/run.googleapis.com?project=vaultwarden-452515&inv=1&invt=Abq-gQ

Enable Secret Manager API: https://console.cloud.google.com/apis/enableflow?apiid=secretmanager.googleapis.com&invt=AbuoDg&project=vaultwarden-452515

Enable Cloud Scheduler API for it: https://console.cloud.google.com/apis/api/cloudscheduler.googleapis.com/overview?project=vaultwarden-452515&inv=1&invt=AbrjLg

Verify the applicable domain: https://search.google.com/search-console/welcome?domain=hockersten.se


```
gcloud auth application-default login
```

Run
```
terraform apply -target google_cloud_run_domain_mapping.vaultwarden
terraform apply
```

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
