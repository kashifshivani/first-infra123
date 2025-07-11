
 data "azurerm_mssql_server" "server" {
  name                = var.sqlserver_name
  resource_group_name = var.resource_group_name
}
 resource "azurerm_mssql_database" "database" {
  name         = var.sql-database-name
  server_id    = data.azurerm_mssql_server.server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"
  geo_backup_enabled  = false 
  storage_account_type = "Local"
}