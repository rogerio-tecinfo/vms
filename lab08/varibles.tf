variable "resourcegroup" {
  type        = list(any)
  description = "Resource Group used for all resources."
  default     = ["az104-08-rg03", "az104-08-rg04"]
}

variable "resourcegroup1" {
  type        = string
  description = "Resource Group used for all resources."
  default     = "az104-08-rg03"
}

variable "resourcegroup2" {
  type        = string
  description = "Resource Group used for all resources."
  default     = "az104-08-rg04"
}

variable "size" {
  type        = string
  description = "Virtual Machine size, Default: Standard_DS1_v2"
  default     = "Standard_DS1_v2"
}

variable "storage_account_type" {
  type        = string
  description = "Virtual Machine Disk type, Default: Standard_LRS"
  default     = "Standard_LRS"
}

variable "name0" {
  type        = string
  description = "Virtual Machine Name."
  default     = "az104-08-vm0"

}

variable "name1" {
  type        = string
  description = "Virtual Machine Name."
  default     = "az104-08-vm1"

}

variable "nic1" {
  type        = string
  description = "Virtual Network Interface Name."
  default     = "az104-08-vm0"
}

variable "nic2" {
  type        = string
  description = "Virtual Network Interface Name."
  default     = "az104-08-vm3"
}

variable "vnet1" {
  type        = string
  description = "Virtual network Name used for all resources"
  default     = "az104-08-rg01-vnet01"
}

variable "vnet2" {
  type        = string
  description = "Virtual network Name used for all resources"
  default     = "az104-08-rg01-vnet02"
}

variable "publicip" {
  type        = string
  description = "The public IP assin to the new VM."
  default     = "az104-08"
}

variable "publicip_sku" {
  type        = string
  description = "The public IP sku: Default Basic"
  default     = "Basic"
}

variable "lb" {
  type        = string
  description = "Virtual network Name used for all resources"
  default     = "az10408vmss-lb"
}

variable "back_pool" {
  type        = string
  description = "Virtual network Name used for all resources"
  default     = "BackEndAddressPool"
}

variable "lbnat_pool" {
  type        = string
  description = "Virtual network Name used for all resources"
  default     = "PublicIPAddress"
}

variable "lb_probe" {
  type        = string
  description = "Virtual network Name used for all resources"
  default     = "http-probe"
}

variable "source_image_reference_publisher" {
  type        = string
  description = "Virtual Machine Publisher, Default: MicrosoftWindowsServer"
  default     = "MicrosoftWindowsServer"
}

variable "source_image_reference_offer" {
  type        = string
  description = "Virtual Machine Offer, Default: WindowsServer"
  default     = "WindowsServer"
}

variable "source_image_reference_sku" {
  type        = string
  description = "Virtual Machine Sku, Default: 2019-Datacenter"
  default     = "2019-Datacenter"
}

variable "source_image_reference_version" {
  type        = string
  description = "Virtual Machine Version, Default: latest"
  default     = "latest"
}

variable "vnetaddress_space1" {
  type        = string
  description = "Address space used for all resources. Recommend subnet config /16"
  default     = "10.80.0.0/20"
}

variable "vnetaddress_space2" {
  type        = string
  description = "Address space used for all resources. Recommend subnet config /16"
  default     = "10.82.0.0/20"
}

variable "subnet0" {
  type        = string
  description = "Subnet Network Name used for all resources"
  default     = "Subnet0"
}

variable "subnet1" {
  type        = string
  description = "Subnet Network Name used for all resources"
  default     = "Subnet1"
}

variable "subnetaddress_prefixes0" {
  type        = string
  description = "Subnet network used for all resources. Recommend subnet config /24"
  default     = "10.80.0.0/24"
}

variable "subnetaddress_prefixes1" {
  type        = string
  description = "Subnet network used for all resources. Recommend subnet config /24"
  default     = "10.82.0.0/24"
}

variable "nsg" {
  type        = string
  description = "Network Security Group Name used for all resources"
  default     = "az10408vmss0-nsg"
}

variable "vmss" {
  type        = string
  description = "Network Security Group Name used for all resources"
  default     = "vmss1"
}

variable "autoscale" {
  type        = string
  description = "Network Security Group Name used for all resources"
  default     = "az10408vmss1-autoscale"
}

variable "user" {
  type        = string
  description = "User Name to connect on the VM."
  default     = "lab.azuser"
}

variable "password" {
  type        = string
  description = "password to connect on the VM."
  default     = "Q1w2e3r4t5%y"
}

variable "location" {
  type        = string
  description = "Azure region used for all resources"
  default     = "eastus2"
}

variable "storage_accountname" {
  type        = string
  description = "Description the storage account name"
  default     = "az10408rg1rsp2209202209"
}

variable "storage_container" {
  type        = string
  description = "Description the storage account name"
  default     = "scripts"
}

variable "storage_blob" {
  type        = string
  description = "Description the storage share name"
  default     = "az104-07-blob"
}

variable "install_IIS" {
  type        = string
  description = "Description the storage share name"
  default     = "install_IIS"
}

variable "install_IIS2" {
  type        = string
  description = "Description the storage share name"
  default     = "install_IIS2"
}

variable "install_IIS_file" {
  type        = string
  description = "Description the storage share name"
  default     = "az104-08-install_IIS.ps1"
}
