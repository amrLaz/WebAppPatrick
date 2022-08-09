resource "azurerm_service_plan" "sp" {
  name                = "as-postgressl-webapp-plan-poc"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "P1v2"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "as-postgresql-webapp-poc"
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
    SCM_DO_BUILD_DURING_DEPLOYMENT=true
    ENABLE_ORYX_BUILD = true
    "DBHOST" = "tf-postgresql-server"
    "DBNAME" = "restaurant"
    "DBUSER" = "AmrAdmin"
    "DBPASS" = azurerm_key_vault_secret.postgresecret.value
    # app insight
#     "APPINSIGHTS_INSTRUMENTATIONKEY"                  = azurerm_application_insights.appinsight.instrumentation_key
#     "APPLICATIONINSIGHTS_CONNECTION_STRING"           = azurerm_application_insights.appinsight.connection_string
#     "APPINSIGHTS_PROFILERFEATURE_VERSION"             = "1.0.0"
#     "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"             = "1.0.0"
#     "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~2"


  }
}


resource "azurerm_app_service_virtual_network_swift_connection" "webappvnetconnection" {
  app_service_id = azurerm_linux_web_app.webapp.id
  subnet_id      = azurerm_subnet.Subnet2.id
}
