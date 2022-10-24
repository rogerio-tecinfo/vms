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
    subnet_id                     = azurerm_subnet.subnet0.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.publicip.id
  }
  depends_on = [azurerm_subnet.subnet1]
}
# Create public IPs
resource "azurerm_public_ip" "publicip" {
  name                = var.publicip
  location            = var.location
  resource_group_name = var.resourcegroup2
  allocation_method   = "Dynamic"
  sku                 = var.publicip_sku
  depends_on          = [azurerm_subnet.subnet1]
  tags = {
    environment = "staging"
  }
}

# Create Load Balance
resource "azurerm_lb" "lb" {
  name                = var.lb
  location            = var.location
  resource_group_name = var.resourcegroup2
  depends_on          = [azurerm_public_ip.publicip]
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

# Create Backend Pool
resource "azurerm_lb_backend_address_pool" "back_pool" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = var.back_pool
  depends_on          = [azurerm_lb.lb]
}

#Create Load Balance Nat Pool
resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = var.resourcegroup2
  name                           = "http"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 80
  frontend_ip_configuration_name = var.lbnat_pool
  depends_on          = [azurerm_lb.lb]
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = var.lb_probe
  protocol            = "Http"
  request_path        = "/*"
  port                = 80
  depends_on          = [azurerm_lb.lb]
}

#Create Network Security Group and rule to open port 80 to Scale Set.
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg
  location            = var.location
  resource_group_name = var.resourcegroup2

  security_rule {
    name                       = "custom-allow-http"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [azurerm_public_ip.publicip]
}

# # Connect the security group to the Load Balance
# resource "azurerm_network_interface_security_group_association" "connectnic" {
#   network_interface_id      = azurerm_network_interface.nic.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
#   depends_on = [azurerm_network_interface.nic, azurerm_network_security_group.nsg,
#   azurerm_public_ip.publicip]
# }

# Create VM Scale Set Windows
resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name                = var.vmss
  resource_group_name = var.resourcegroup2
  location            = var.location
  sku                 = "Standard_B2s"
  instances           = 1
  admin_password      = var.password
  admin_username      = var.user
  
  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }

  os_disk {
    storage_account_type = var.storage_account_type
    caching              = "ReadWrite"
  }

  network_interface {
    name    = var.vmss
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.subnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.back_pool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = var.autoscale
  resource_group_name = var.resourcegroup2
  location            = var.location
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.vmss.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["rogerio.prazeres@outlook.com.br"]
    }
  }
}

# Create virtual machines
resource "azurerm_windows_virtual_machine" "name0" {
  name                  = var.name0
  location              = var.location
  resource_group_name   = var.resourcegroup1
  network_interface_ids = [azurerm_network_interface.nic1.id]
  size                  = var.size
  zone                  = "1"
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
  network_interface_ids = [azurerm_network_interface.nic2.id]
  size                  = var.size
  zone                  = "1"

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

  depends_on = [azurerm_windows_virtual_machine.name0,azurerm_subnet.subnet1]

}

# Create VM Extesion to execute powershell file
locals {
  PowerShellScript= try(file("az104-08-install_IIS.ps1"), null)
  base64EncodedScript = base64encode(local.PowerShellScript)
}

# resource "azurerm_virtual_machine_extension" "install_IIS" {
#   name                 = var.install_IIS
#   virtual_machine_id   = azurerm_windows_virtual_machine.name0.id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "2.0"

#   settings = <<SETTINGS
#     { 
#       "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::
#       FromBase64String('${local.base64EncodedScript }')) | Out-File -filepath az104-08-install_IIS.ps1\"
#        && powershell -ExecutionPolicy Unrestricted -File az104-08-install_IIS.ps1"  
#     }
#     SETTINGS
#   depends_on = [azurerm_windows_virtual_machine.name0]
# }

resource "azurerm_virtual_machine_extension" "install_IIS" {
  name                 = var.install_IIS
  virtual_machine_id   = azurerm_windows_virtual_machine.name1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    { 
      "fileUris": ["https://az10408rg1rsp2209202209.blob.core.windows.net/scripts/az104-08-install_IIS.ps1"],
      "commandToExecute": "powershell.exe az104-08-install_IIS.ps1",
      "managedIdentity" : {}       
    } 
    SETTINGS
  depends_on = [azurerm_windows_virtual_machine.name1]
}
# Create Storage Account
resource "azurerm_storage_account" "storage_accountname" {
  name                     = var.storage_accountname
  resource_group_name      = var.resourcegroup1
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
  name                   = var.install_IIS_file
  storage_account_name   = var.storage_accountname
  storage_container_name = var.storage_container
  type                   = "Block"
  source                 = "az104-08-install_IIS.ps1"
  depends_on             = [azurerm_storage_account.storage_accountname]
}