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

## Adding environment variables

You need:
```
GIT_USERNAME=ahockersten
GITHUB_TOKEN=<token created in previous step>
```

# Running terraform

```
terraform init
terraform validate
terraform plan --out terraform.plan
```

Check that everything looks OK. You will see that it will try to create the already existing state.. This is bad! We need to import what we created in previous steps:

```
terraform import azurerm_resource_group.rg_ahockersten_default /subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP
terraform import azurerm_storage_account.ahockerstentfstorage /subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT
terraform import azurerm_storage_container.tf_state https://ahockerstentfstorage.blob.core.windows.net/$STORAGE_CONTAINER_NAME
```

Now, we can finally apply the terraform config:

```
terraform plan --out tfplan
terraform apply tfplan
```
