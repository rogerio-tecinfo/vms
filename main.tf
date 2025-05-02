# Obter dados dos recursos existentes
data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "existing" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.existing.name
}

data "azurerm_subnet" "existing" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = data.azurerm_resource_group.existing.name
}

data "azurerm_network_security_group" "existing" {
  name                = var.nsg_name
  resource_group_name = data.azurerm_resource_group.existing.name
}

# Criar a interface de rede associada ao NSG existente
resource "azurerm_network_interface" "example" {
  count               = length(var.vm_names)
  name                = "${var.vm_names[count.index]}-nic"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.existing.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Associar o NSG existente à interface de rede
resource "azurerm_network_interface_security_group_association" "example" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.example[count.index].id
  network_security_group_id = data.azurerm_network_security_group.existing.id
}

# Criar a VM Windows
resource "azurerm_windows_virtual_machine" "example" {
  count               = length(var.vm_names)
  name                = var.vm_names[count.index]
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
  azurerm_network_interface.example[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  # Configurações específicas para Windows
  enable_automatic_updates = true
  provision_vm_agent       = true
}

# Criar a VM Windows
resource "azurerm_windows_virtual_machine" "example1" {
  count               = length(var.vm_names)
  name                = var.vm_names[count.index]
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
  azurerm_network_interface.example[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = var.image_publisher1
    offer     = var.image_offer1
    sku       = var.image_sku1
    version   = var.image_version
  }

  # Configurações específicas para Windows
  enable_automatic_updates = true
  provision_vm_agent       = true
}