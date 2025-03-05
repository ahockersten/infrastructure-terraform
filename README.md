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

Enable Site Verification API for it: https://console.cloud.google.com/marketplace/product/google/siteverification.googleapis.com?q=search&referrer=search&inv=1&invt=AbrPhw&project=vaultwarden-452515


```
gcloud auth application-default login
```

Run
```
terraform apply
```
