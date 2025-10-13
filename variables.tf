variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "my-resource-group"
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "East US"
}

variable "org_service_url" {
  description = "Azure DevOps organization service URL"
  type        = string
}

variable "personal_access_token" {
  description = "Azure DevOps personal access token"
  type        = string
  sensitive   = true
}

variable "sql_administrator_login" {
  type        = string
  sensitive   = true
}

variable "sql_administrator_login_password" {
  type        = string
  sensitive   = true
}
