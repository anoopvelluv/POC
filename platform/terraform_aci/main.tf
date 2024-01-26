data "azurerm_resource_group" "rg" {
  name     = var.rg_name
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_user_assigned_identity" "identity" {
  location            = var.location
  name                = "identityACI"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "clientconfig" {
}

resource "azurerm_role_assignment" "assignrole" {
  scope                = data.azurerm_container_registry.acr.location
  role_definition_name = "acrpull"
  principal_id         = data.azurerm_client_config.clientconfig.object_id
}

resource "azurerm_container_group" "aci" {
  name  = "docker-container-instance"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = var.location
  ip_address_type     = "Public"
  os_type= "Linux"

  identity {
    type = "UserAssigned"
    identity_ids = ["/subscriptions/7122eee9-66c8-4e94-8a9a-56733a94bc91/resourcegroups/${data.azurerm_resource_group.rg.name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${azurerm_user_assigned_identity.identity.name}"]
  }

  container {
    name   = "pocimagedemo"
    image  = "${data.azurerm_container_registry.acr.login_server}/simulationdeploypocacr:${var.build_id}"
    cpu    = "0.5"
    memory = "1.5"

     ports {
      port     = 80
      protocol = "TCP"
    }
  }

}