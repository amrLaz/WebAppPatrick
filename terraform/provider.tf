# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
  backend "azurerm" {
    resource_group_name  = "RG-REMOTE-BACKEND"
    storage_account_name = "tfstatestorageamr"
    container_name       = "tfstate1"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {

  features {}
}

