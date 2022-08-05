data "azurerm_client_config" "current" {}

resource "random_password" "self" {
  length           = 25
  special          = true
  lower            = true
  upper            = true
  override_special = "_%@"
}
resource "azurerm_key_vault" "keyvault" {
  name                       = "kv-poctest-amr"
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
  name         = "kv-secret-webapp-poc-postgre"
  value        = random_password.self.result
  key_vault_id = azurerm_key_vault.keyvault.id
}
