# Security group para Master
resource "azurerm_network_security_group" "az_vm_master_secgroup" {
    name                = "master_sg"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "http"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    tags = {
        environment = "CP2"
    }
}

#Security group para Workers
resource "azurerm_network_security_group" "az_vm_worker_secgroup" {
    name                = "worker_sg"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "CP2"
    }
}

# Bind sg2NIC Master

resource "azurerm_network_interface_security_group_association" "az_vm_secgroup_bind_master" {
  network_interface_id      = azurerm_network_interface.vm_nic_master.id
  network_security_group_id = azurerm_network_security_group.az_vm_master_secgroup.id
}

#Bind sg2NIC Workers
resource "azurerm_network_interface_security_group_association" "az_vm_secgroup_bind_workers" {
  count                     = length(var.vm_workers)
  network_interface_id      = azurerm_network_interface.vm_nic_worker[count.index].id
  network_security_group_id = azurerm_network_security_group.az_vm_worker_secgroup.id
}
