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
