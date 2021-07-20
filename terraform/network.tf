#Creamos la red en el Resource Group
resource "azurerm_virtual_network" "az_net" {
  name  = "kubernetes"
  address_space  = ["172.0.0.0/12"]
  location  = var.location
  resource_group_name  = azurerm_resource_group.rg.name
}

#Creamos la subnet dentro de la red creada anteriormente
resource "azurerm_subnet" "az_subnet" {
  name                 = "terraformsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.az_net.name
  address_prefixes     = ["172.0.1.0/24"]
}


#Creación NIC Master
resource "azurerm_network_interface" "vm_nic_master" {
  name                = "vm_nic_master"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfiguration_master"
    subnet_id                     = azurerm_subnet.az_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.0.1.10"
    public_ip_address_id          = azurerm_public_ip.az_public_ip_master.id
  }

  tags = {
    environment = "CP2"
  }
}

#Creación NIC Workers
#En este caso las creamos dependiendo del número de workers existentes
resource "azurerm_network_interface" "vm_nic_worker" {
  count               = length(var.vm_workers)
  name                = "vm_nic_${var.vm_workers[count.index]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfiguration_worker${var.vm_workers[count.index]}"
    subnet_id                     = azurerm_subnet.az_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.0.1.${count.index + 11}"
    public_ip_address_id          = azurerm_public_ip.az_public_ip_workers[count.index].id
  }

  tags = {
    environment = "CP2"
  }
}


#Creamos IP pública Master
resource "azurerm_public_ip" "az_public_ip_master" {
  name                = "master_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  tags = {
    environment = "CP2"
  }
}
#Creamos IP pública workers
resource "azurerm_public_ip" "az_public_ip_workers" {
  count               = length(var.vm_workers)
  name                = "worker_ip_${var.vm_workers[count.index]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  tags = {
    environment = "CP2"
  }
}
