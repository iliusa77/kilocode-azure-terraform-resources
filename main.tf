# Resource Group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Azure API Management
resource "azurerm_api_management" "example" {
  name                = "example-apim"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = "My Company"
  publisher_email     = "company@example.com"
  sku_name            = "Developer_1"
}

# Azure App Services
resource "azurerm_app_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Windows"
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
}

# Azure App Service for Containers
resource "azurerm_app_service_plan" "container" {
  name                = "example-container-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "container" {
  name                = "example-container-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.container.id
  site_config {
    linux_fx_version = "DOCKER|nginx:latest"
  }
}

# Azure Container Registry
resource "azurerm_container_registry" "example" {
  name                = "exampleacr"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
  admin_enabled       = false
}

# Azure Function App
resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacct"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "function" {
  name                = "example-function-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "FunctionApp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "example" {
  name                       = "example-function-app"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.function.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  version                    = "~3"
}

# Azure Static Web Apps
resource "azurerm_static_site" "example" {
  name                = "example-static-web-app"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_tier            = "Free"
  sku_size            = "Free"
}

# Azure Entra ID (Azure AD)
resource "azuread_application" "example" {
  display_name = "example-app"
}

resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
}

# Azure Entra External ID (B2C)
resource "azurerm_aadb2c_directory" "example" {
  country_code            = "US"
  data_residency_location = "United States"
  display_name            = "example-b2c"
  domain_name             = "exampleb2c.onmicrosoft.com"
  sku_name                = "PremiumP1"
}

# Azure SQL Server
resource "azurerm_sql_server" "example" {
  name                         = "example-sql-server"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login
  administrator_login_password = var.sql_administrator_login_password
}

resource "azurerm_sql_database" "example" {
  name                = "example-db"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  server_name         = azurerm_sql_server.example.name
  edition             = "Standard"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_bytes      = "1073741824"
  requested_service_objective_name = "S0"
}

# Azure App Insights
resource "azurerm_application_insights" "example" {
  name                = "example-app-insights"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

# Azure Monitor
resource "azurerm_monitor_action_group" "example" {
  name                = "example-action-group"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "exampleag"
}

resource "azurerm_monitor_metric_alert" "example" {
  name                = "example-metric-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_application_insights.example.id]
  description         = "Action will be triggered when CPU usage is greater than 80%"

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

# Azure DevOps Pipeline
resource "azuredevops_project" "example" {
  name       = "example-project"
  visibility = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}

resource "azuredevops_build_definition" "example" {
  project_id = azuredevops_project.example.id
  name       = "example-pipeline"
  path       = "\\"

  repository {
    repo_type   = "GitHub"
    repo_id     = "microsoft/terraform-provider-azuredevops"
    branch_name = "main"
    yml_path    = "azure-pipelines.yml"
  }
}

# Azure DevOps Library Group
resource "azuredevops_variable_group" "example" {
  project_id   = azuredevops_project.example.id
  name         = "example-variable-group"
  description  = "Example variable group"
  allow_access = true

  variable {
    name  = "example_var"
    value = "example_value"
  }
}