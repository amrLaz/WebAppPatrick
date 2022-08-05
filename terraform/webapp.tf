resource "azurerm_service_plan" "sp" {
  name                = "python-postgres-webapp-plan-amr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "P1v2"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "python-postgresql-webapp-amr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {
    always_on = true
    # http2_enabled = true
    # application_stack {
    #   python_version  = 3.9
    # }
  }

  app_settings = {
    "DBHOST" = "tf-postgresql-server"
    "DBNAME" = "restaurant"
    "DBUSER" = "AmrAdmin"
    "DBPASS" = azurerm_key_vault_secret.postgresecret.value
  }
}


resource "azurerm_app_service_virtual_network_swift_connection" "webappvnetconnection" {
  app_service_id = azurerm_linux_web_app.webapp.id
  subnet_id      = azurerm_subnet.Subnet2.id
}