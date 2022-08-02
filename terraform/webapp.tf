resource "azurerm_service_plan" "sp" {
  name                = "appserviceplantest"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "P1v2"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "webapp" {
  name                = "WebappAmrpostgre"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {}

#   app_settings = {
#     "DBHOST" = "value"
#     "DBNAME" = "mypostgre"
#     "DBUSER" = "admin"
#     "DBPASS" = azurerm_key_vault_secret.postgresecret.value
#   }
}


resource "azurerm_app_service_virtual_network_swift_connection" "webappvnetconnection" {
  app_service_id = azurerm_windows_web_app.webapp.id
  subnet_id      = azurerm_subnet.Subnet2.id
}