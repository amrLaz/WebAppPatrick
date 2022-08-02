resource "azurerm_resource_group" "rg" {
  name     = "RG-test-webapp-psqldb"
  location = "West Europe"
  tags = {
    ENV : "Test WebAppSlot"
  }
}