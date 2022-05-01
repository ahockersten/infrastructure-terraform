# Useful variables

These are used below, but _also in Terraform's `main.tf`_ (so changing them requires changing there as well)

```
AZURE_TENANT_ID=8fbc5cea-2448-4779-a0e9-31d74029e14d
AZURE_SUBSCRIPTION_ID=673d5161-7521-43bd-b861-1838d3b62eb9
STORAGE_ACCOUNT=ahockerstentfstorage
STORAGE_CONTAINER_NAME=tf-state
RESOURCE_GROUP=rg-ahockersten-default
LOCATION=swedencentral
```

# Initial setup

## Adding terraform variables

Create a `terraform.tfvars`. It should contain:

```
cloudflare_api_token = "<secret_token>"
```

## Setting up Azure

Make sure you have `direnv` so you can get access to the right accounts. Add
something like this to a local .env:

```
export AZURE_TENANT_ID=8fbc5cea-2448-4779-a0e9-31d74029e14d
export AZURE_CONFIG_DIR=/home/anders/git/personal/.azure
export KUBECONFIG=/home/anders/git/personal/.kubeconfig
```

You then need to login to your account with:

```
az login --tenant $TENANT_ID
```

## Bootstrapping Azure

You will need to create an initial resource group and storage account manually via the CLI:

```
az group create --name $RESOURCE_GROUP --location $LOCATION

az storage account create --resource-group $RESOURCE_GROUP --name $STORAGE_ACCOUNT --location $LOCATION --sku Standard_LRS --kind StorageV2

az storage container create --name $STORAGE_CONTAINER_NAME --account-name $STORAGE_ACCOUNT
```

# Running terraform

```
terraform init
terraform validate
terraform plan
```

Check that everything looks OK.

```
terraform apply
```
