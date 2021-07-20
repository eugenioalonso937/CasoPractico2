# Creamos la máquina Master/NFS

resource "azurerm_linux_virtual_machine" "vm_template_master" {

    name                = "master"
    resource_group_name = azurerm_resource_group.rg.name
    admin_username      = var.ssh_user
    location            = azurerm_resource_group.rg.location
    size                = var.vm_size_master
    network_interface_ids = [ azurerm_network_interface.vm_nic_master.id ]
    disable_password_authentication = true

    admin_ssh_key {
        username   = var.ssh_user
        public_key = file(var.public_key_path)
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
    }

    tags = {
        environment = "CP2"
    }

}

# Creamos los workers
resource "azurerm_linux_virtual_machine" "vm_template_worker" {

    count               = length(var.vm_workers)
    name                = "${var.vm_workers[count.index]}"
    resource_group_name = azurerm_resource_group.rg.name
    admin_username      = var.ssh_user
    location            = azurerm_resource_group.rg.location
    size                = var.vm_size_worker
    network_interface_ids = [ azurerm_network_interface.vm_nic_worker[count.index].id ]
    disable_password_authentication = true

    admin_ssh_key {
        username   = var.ssh_user
        public_key = file(var.public_key_path)
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
    }

    tags = {
        environment = "CP2"
    }

}
