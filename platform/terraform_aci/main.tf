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

#resource "azurerm_role_assignment" "test" {
#  scope                = "${data.azurerm_subscription.primary.id}"
#  role_definition_name = "Reader"
#  principal_id         = "${data.azurerm_client_config.clientconfig.service_principal_object_id}"
#}

#resource "azurerm_role_definition" "role_assignment_contributor" {
#    name  = "Role Assignment Owner"
#    scope = data.azurerm_subscription.primary.id
#    description = "A role designed for writing and deleting role assignments"
#
#    permissions {
#        actions = [
#            "Microsoft.Authorization/roleAssignments/write",
#            "Microsoft.Authorization/roleAssignments/delete",
#        ]
#        not_actions = []
#    }
#
#    assignable_scopes = [
#        data.azurerm_subscription.primary.id
#    ]
#}
#
#resource "azurerm_role_assignment" "assigncustomrole" {
#  scope              = data.azurerm_subscription.primary.id
#  role_definition_id = azurerm_role_definition.role_assignment_contributor.role_definition_resource_id
#  principal_id       = data.azurerm_client_config.clientconfig.object_id
#}

resource "azurerm_role_assignment" "assignrole" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = data.azurerm_client_config.clientconfig.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_container_group" "aci" {
  name  = "docker-container-instance"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = var.location
  ip_address_type     = "Public"
  os_type= "Linux"

  identity {
    type = "UserAssigned"
    identity_ids = ["/subscriptions/7122eee9-66c8-4e94-8a9a-56733a94bc91/resourceGroups/${data.azurerm_resource_group.rg.name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${azurerm_user_assigned_identity.identity.name}"]
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