resource "azurerm_storage_account" "ahockerstentfstorage" {
  name                     = "ahockerstentfstorage"
  resource_group_name      = azurerm_resource_group.rg_ahockersten_default.name
  location                 = azurerm_resource_group.rg_ahockersten_default.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tf_state" {
  name                  = "tf-state"
  storage_account_name  = azurerm_storage_account.ahockerstentfstorage.name
  container_access_type = "private"
}
