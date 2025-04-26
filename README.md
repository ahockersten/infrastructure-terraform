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

# Creating the necessary google credentials

**NOTE!** You will probably need to run and rerun a bit depending on how the `terraform` commands go. You'll need projects to be created before you can use them below, but you might need the policy bindings to be created before you can resources in the projects.

```
export PROJECT_ID=vaultwarden-452515
export GITHUB_ORG=ahockersten
export EMAIL=anders.hockersten@gmail.com
export REPO_NAME=vaultwarden-backup
export POOL_ID=github
gcloud auth login

# the policy bindings make sure the user account can run terraform correctly
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="user:${EMAIL}" \
    --role="roles/iam.serviceAccountTokenCreator"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="user:${EMAIL}" \
    --role="roles/iam.workloadIdentityPoolAdmin"

# this ensures workloads running on github can access the GAR for this repo.
gcloud iam workload-identity-pools create "${POOL_ID}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --display-name="GitHub Actions Pool"

export WORKLOAD_IDENTITY_POOL_ID=`gcloud iam workload-identity-pools describe "${POOL_ID}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --format="value(name)"`

export PROJECT_NUMBER=`echo $WORKLOAD_IDENTITY_POOL_ID | cut -d'/' -f2`

gcloud iam workload-identity-pools providers create-oidc "${REPO_NAME}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="${POOL_ID}" \
  --display-name="My GitHub repo Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
  --attribute-condition="assertion.repository_owner == '${GITHUB_ORG}'" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# this allows uploading of an artifact from the repo
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --role="roles/artifactregistry.writer" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${GITHUB_ORG}/${REPO_NAME}"

# this allows deploying to cloud run
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --role="roles/run.developer" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${GITHUB_ORG}/${REPO_NAME}"

# this is also needed to deploy to cloud run
gcloud iam service-accounts add-iam-policy-binding \
  ${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --member="principal://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/subject/repo:${GITHUB_ORG}/${REPO_NAME}:ref:refs/heads/main" \
  --role="roles/iam.serviceAccountUser" \
  --project=${PROJECT_ID}

# The output from this command is what is needed to be entered into github workflows for $REPO_NAME
gcloud iam workload-identity-pools providers describe ${REPO_NAME} \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="${POOL_ID}" \
  --format="value(name)"
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

Run:
```
gcloud auth application-default login
terraform apply -target google_cloud_run_domain_mapping.vaultwarden
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
