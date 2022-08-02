resource "azurerm_resource_group" "rg" {
  name     = "RG-test-webapp-sqldb"
  location = "West Europe"
  tags = {
    ENV : "Test WebAppSlot"
  }
}