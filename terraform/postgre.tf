

resource "azurerm_postgresql_server" "postgreserv" {
  name                = "tf-postgresql-server"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "GP_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "adminpostgre"
  administrator_login_password = azurerm_key_vault_secret.postgresecret.value
  version                      = "9.5"
  ssl_enforcement_enabled      = true
#   public_network_access_enabled = false
    
}

resource "azurerm_private_endpoint" "postgreprivateendpoint" {
  name                = "postgre-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.Subnet1.id

  private_service_connection {
    name                           = "postgreprivateserviceconnection"
    private_connection_resource_id = azurerm_postgresql_server.postgreserv.id
    subresource_names              = [ "postgresqlServer" ]
    is_manual_connection           = false
  }
}

# resource "azurerm_postgresql_database" "postgredb" {
#   name                = "tf-postgredb"
#   resource_group_name = azurerm_resource_group.rg.name
#   server_name         = azurerm_postgresql_server.postgreserv.name
#   charset             = "UTF8"
#   collation           = "English_United States.1252"
# }

