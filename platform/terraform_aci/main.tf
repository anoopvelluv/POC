data "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_container_group" "aci" {
  name  = "docker-container-instance"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  ip_address_type     = "public"
  os_type= "Linux"

  container {
    name   = "pocimagedemo"
    image  = "${data.azurerm_container_registry.acr.login_server}/aci:${var.build_id}"
    cpu    = "0.5"
    memory = "1.5"
  }

}