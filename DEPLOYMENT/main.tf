module "rg" {
  source                  = "../TEST/azure_rg"
  resource_group_name     = "kash-rg"
  resource_group_location = "indonesia central"

}

module "rg1" {
  source                  = "../TEST/azure_rg"
  resource_group_name     = "kash-rg1"
  resource_group_location = "indonesia central"

}

module "vnet" {
  depends_on          = [module.rg]
  source              = "../TEST/azure_vnet"
  vnet_name           = "kash-vnet"
  vnet_location       = "indonesia central"
  resource_group_name = "kash-rg"
  address_space       = ["10.0.0.0/16"]

}
module "f-subnet" {
  depends_on           = [module.vnet]
  source               = "../TEST/azure_subnet"
  subnet_name          = "front1-subnet"
  resource_group_name  = "kash-rg"
  virtual_network_name = "kash-vnet"
  address_prefix       = ["10.0.0.0/24"]

}
module "b-subnet" {
  depends_on           = [module.vnet]
  source               = "../TEST/azure_subnet"
  subnet_name          = "back1-subnet"
  resource_group_name  = "kash-rg"
  virtual_network_name = "kash-vnet"
  address_prefix       = ["10.0.1.0/24"]

}
module "f-pip" {
  depends_on          = [module.rg]
  source              = "../TEST/azure_pip"
  pip_name            = "front-pip"
  resource_group_name = "kash-rg"
  location            = "indonesia central"
  allocation_method   = "Static"

}
module "b-pip" {
  depends_on          = [module.rg]
  source              = "../TEST/azure_pip"
  pip_name            = "back-pip"
  resource_group_name = "kash-rg"
  location            = "indonesia central"
  allocation_method   = "Static"

}
module "front_vm" {
  depends_on          = [module.f-subnet, module.f-pip]
  source              = "../TEST/azure_vm"
  vm_name             = "front-vm"
  resource_group_name = "kash-rg"
  location            = "indonesia central"
  vm_size             = "Standard_F2"
  key_vault_name      = "kamnigarankv"
  kv_rg               = "kkk-rg"
  username            = "vm-username"
  password            = "vm-password"


  nic_name  = "f-nic"
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"

  subnet_name = "front1-subnet"
  vnet_name   = "kash-vnet"
  pip_name    = "front-pip"
}
module "back_vm" {
  depends_on          = [module.b-subnet, module.b-pip]
  source              = "../TEST/azure_vm"
  vm_name             = "back-vm"
  resource_group_name = "kash-rg"
  location            = "indonesia central"
  vm_size             = "Standard_B1s"
  key_vault_name      = "kamnigarankv"
  kv_rg               = "kkk-rg"
  username            = "vm-username"
  password            = "vm-password"



  nic_name  = "b-nic"
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"

  subnet_name = "back1-subnet"
  vnet_name   = "kash-vnet"
  pip_name    = "back-pip"
}

module "sqlserver" {
  depends_on                   = [module.rg]
  source                       = "../TEST/azure_server"
  sqlserver_name               = "kash-sqlserver"
  resource_group_name          = "kash-rg"
  location                     = "indonesia central"
  administrator_login          = "sqladmin"
  administrator_login_password = "Asunny@1234567"

}

module "azure_database" {
  depends_on        = [module.sqlserver]
  source            = "../TEST/azure_database"
  sql-database-name = "kash-sqldb"

  resource_group_name = "kash-rg"
  sqlserver_name      = "kash-sqlserver"


}

# module "key_vault" {
#   depends_on = [ module.rg ]
#   source              = "../TEST/azure_keyvault"
#   key_vault_name      = "k-kv"
#   location            = "indonesia central"
#   resource_group_name = "kash-rg"

# }

# module "vm-username" {
#   depends_on          = [module.key_vault]
#   source              = "../TEST/azure_key_vault_secret"
#   secret_name         = "vm-username"
#   secret_value      = "sunny"
#   key_vault_name      = "k-kv"  
#   resource_group_name = " kash-rg"


# }

# module "vm-password" {
#   source              = "../TEST/azure_key_vault_secret"
#   secret_name         = "vm-password"
#   secret_value      = "Asunny@1234567"
#   key_vault_name      = "k-kv"  
#   resource_group_name = " kash-rg"
#   depends_on          = [module.key_vault]

# }