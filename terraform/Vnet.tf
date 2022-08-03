resource "azurerm_virtual_network" "Vnet1" {
  name                = "VirtualNetwork1"
  address_space       = ["10.0.0.0/25"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "Subnet1" {
  name                 = "Subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.Vnet1.name
  address_prefixes     = ["10.0.0.0/28"]
  #   service_endpoints    = ["Microsoft.Sql"]
  enforce_private_link_service_network_policies = true
}

resource "azurerm_subnet" "Subnet2" {
  name                 = "Subnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.Vnet1.name
  address_prefixes     = ["10.0.0.16/28"]
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


resource "azurerm_network_security_group" "NSG1" {
  name                = "NetworkSecurityGroup1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  #   security_rule {
  #     name                       = "DenyAllInBound"
  #     priority                   = 102
  #     direction                  = "Inbound"
  #     access                     = "Deny"
  #     protocol                   = "*"
  #     source_port_range          = "*"
  #     destination_port_range     = "*"
  #     source_address_prefix      = "*"
  #     destination_address_prefix = "*"
  #   }
  #  security_rule {
  #     name                       = "AllowAzureLoadBalancerInB"
  #     priority                   = 101
  #     direction                  = "Inbound"
  #     access                     = "Allow"
  #     protocol                   = "*"
  #     source_port_range          = "*"
  #     destination_port_range     = "*"
  #     source_address_prefix      = "AzureLoadBalancer"
  #     destination_address_prefix = "*"
  #   }
  #   security_rule {
  #     name                       = "AllowVnetInBound"
  #     priority                   = 103
  #     direction                  = "Inbound"
  #     access                     = "Allow"
  #     protocol                   = "*"
  #     source_port_range          = "*"
  #     destination_port_range     = "*"
  #     source_address_prefix      = "VirtualNetwork"
  #     destination_address_prefix = "VirtualNetwork"
  #   }
  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_network_security_group_association" "NSG1ToSubnet1" {
  subnet_id                 = azurerm_subnet.Subnet1.id
  network_security_group_id = azurerm_network_security_group.NSG1.id
}