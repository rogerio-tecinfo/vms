# Create resource group
resource "azurerm_resource_group" "resourcegroup" {
  count    = 2
  name     = element(var.resourcegroup, count.index)
  location = var.location
}

# Create virtual network1
resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet1
  address_space       = [var.vnetaddress_space1]
  location            = var.location
  resource_group_name = var.resourcegroup1
  depends_on          = [azurerm_resource_group.resourcegroup]
}

# Create virtual network2
resource "azurerm_virtual_network" "vnet2" {
  name                = var.vnet2
  address_space       = [var.vnetaddress_space2]
  location            = var.location
  resource_group_name = var.resourcegroup2
  depends_on          = [azurerm_resource_group.resourcegroup]
}

# Create subnet0
resource "azurerm_subnet" "subnet0" {
  name                 = var.subnet0
  resource_group_name  = var.resourcegroup1
  virtual_network_name = var.vnet1
  address_prefixes     = [var.subnetaddress_prefixes0]
  depends_on           = [azurerm_resource_group.resourcegroup,azurerm_virtual_network.vnet1]
}

# Create subnet1
resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1
  resource_group_name  = var.resourcegroup2
  virtual_network_name = var.vnet2
  address_prefixes     = [var.subnetaddress_prefixes1]
  depends_on           = [azurerm_resource_group.resourcegroup,azurerm_virtual_network.vnet2]
}

# Create network interface to both vms
resource "azurerm_network_interface" "nic1" {
  name                = var.nic1
  location            = var.location
  resource_group_name = var.resourcegroup1

  ip_configuration {
    name                          = "${var.name0}nicconfiguration"
    subnet_id                     = azurerm_subnet.subnet0.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.publicip.id
  }
  depends_on = [azurerm_subnet.subnet0]
}
resource "azurerm_network_interface" "nic2" {
  name                = var.nic2
  location            = var.location
  resource_group_name = var.resourcegroup1

  ip_configuration {
    name                          = "${var.name1}nicconfiguration"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.publicip.id
  }
  depends_on = [azurerm_subnet.subnet1]
}
# # Create public IPs
# resource "azurerm_public_ip" "publicip" {
#   name                = var.publicip
#   location            = var.location
#   resource_group_name = var.resourcegroup1
#   allocation_method   = "Dynamic"
#   sku                 = var.publicip_sku
#   depends_on          = [azurerm_subnet.subnet]

# }

# Create Network Security Group and rule to open port 3389 to internet.
# resource "azurerm_network_security_group" "nsg" {
#   name                = var.nsg
#   location            = azurerm_network_security_group.nsg.location
#   resource_group_name = var.resourcegroup1

#   security_rule {
#     name                       = "RDP"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "33389"
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   depends_on = [azurerm_public_ip.publicip]
# }

# Connect the security group to the network interface
# resource "azurerm_network_interface_security_group_association" "connectnic" {
#   network_interface_id      = azurerm_network_interface.nic.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
#   depends_on = [azurerm_network_interface.nic, azurerm_network_security_group.nsg,
#   azurerm_public_ip.publicip]
# }

# Create virtual machines
resource "azurerm_windows_virtual_machine" "name0" {
  name                  = var.name0
  location              = var.location
  resource_group_name   = var.resourcegroup1
  network_interface_ids = [azurerm_network_interface.nic1.id]
  size                  = var.size

  os_disk {
    name                 = "${var.name0}_osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }

  computer_name  = var.name0
  admin_username = var.user
  admin_password = var.password
  #    disable_password_authentication = true

  depends_on = [azurerm_subnet.subnet0]
}

resource "azurerm_windows_virtual_machine" "name1" {
  name                  = var.name1
  location              = var.location
  resource_group_name   = var.resourcegroup1
  network_interface_ids = [azurerm_network_interface.nic1.id]
  size                  = var.size

  os_disk {
    name                 = "${var.name1}_osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }

  computer_name  = var.name1
  admin_username = var.user
  admin_password = var.password
  #    disable_password_authentication = true

  depends_on = [azurerm_subnet.subnet1]

}

# Create Storage Account
resource "azurerm_storage_account" "storage_accountname" {
  name                     = var.storage_accountname
  resource_group_name      = var.resourcegroup2
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
  depends_on               = [azurerm_resource_group.resourcegroup]
  tags = {
    environment = "staging"
  }
}

# Create Storage Container
resource "azurerm_storage_container" "storage_container" {
  name                  = var.storage_container
  storage_account_name  = var.storage_accountname
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.storage_accountname]
}

# Create Storage Blob
resource "azurerm_storage_blob" "storage_blob" {
  name                   = var.install_IIS
  storage_account_name   = var.storage_accountname
  storage_container_name = var.storage_container
  type                   = "Block"
  source                 = "az104-08-install_IIS.ps1"
  depends_on             = [azurerm_storage_account.storage_accountname]
}