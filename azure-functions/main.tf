resource "azurerm_resource_group" "main" {
  location = var.resource-group-location
  name     = var.resource-group-name
}

resource "azurerm_storage_account" "main" {
  account_replication_type = var.storage_account-replication_type
  account_tier             = var.storage_account-account_tier
  location                 = azurerm_resource_group.main.location
  name                     = var.storage_account-name
  resource_group_name      = azurerm_resource_group.main.name
}

resource "azurerm_app_service_plan" "main" {
  location            = azurerm_resource_group.main.location
  name                = var.app_service_plan-name
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_linux_function_app" "main" {
  location            = azurerm_resource_group.main.location
  name                = var.linux_function_app-name
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_app_service_plan.main.id
}

resource "azurerm_function_app_function" "main" {
  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "function"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "req"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "$return"
        "type"      = "http"
      },
    ]
  })
  function_app_id = azurerm_linux_function_app.main.id
  name            = var.function_app_function-name
}
