data "azurerm_resource_group" "rg" {
  name     = var.rg_name
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_container_group" "aci" {
  name  = "docker-container-instance"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = var.location
  ip_address_type     = "Public"
  os_type= "Linux"

  container {
    name   = "pocimagedemo"
    image  = "${data.azurerm_container_registry.acr.login_server}/aci:${var.build_id}"
    cpu    = "0.5"
    memory = "1.5"

     ports {
      port     = []
      protocol = []
    }
  }

}