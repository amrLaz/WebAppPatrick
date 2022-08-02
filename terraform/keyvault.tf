data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                       = "tf-keyvault"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "postgresecret" {
  name         = "postgresecretwebapp"
  value        = var.postgre_secret.secret_value
  key_vault_id = azurerm_key_vault.keyvault.id
}
