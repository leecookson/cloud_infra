variable "location" {
  description = "The Azure region for the resources."
  type        = string
  default     = "EastUS" # Choose a region appropriate for your resources
}

resource "azurerm_resource_group" "dns" {
  name     = "dnsresources"
  location = var.location
}

resource "azurerm_dns_zone" "az_cookson_pro" {
  name                = "az.cookson.pro"
  resource_group_name = azurerm_resource_group.dns.name
}

output "name_servers" {
  value = azurerm_dns_zone.az_cookson_pro.name_servers
}