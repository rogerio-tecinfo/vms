variable "resourcegroup" {
  type        = string
  description = "Resource Group used for all resources."
  default     = "Cloud-Lab-demo"
}

variable "size" {
  type        = string
  description = "Virtual Machine size, Default: Standard_A1_v2"
  default     = "Standard_A1_v2"
}

variable "storage_account_type" {
  type        = string
  description = "Virtual Machine Disk type, Default: Standard_LRS"
  default     = "Standard_LRS"
}

variable "name" {
  type        = string
  description = "Virtual Machine Name."
  default     = "WIN2k19"
}

variable "nic" {
  type        = string
  description = "Virtual Network Interface Name."
  default     = "Cloud-Lab-demo-nic"
}

variable "vnet" {
  type        = string
  description = "Virtual network Name used for all resources"
  default     = "Cloud-Lab-demo-vnet"
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

variable "vnetaddress_space" {
  type        = string
  description = "Address space used for all resources. Recommend subnet config /16"
  default     = "10.0.0.0/16"
}

variable "subnet" {
  type        = string
  description = "Subnet Network Name used for all resources"
  default     = "Cloud-Lab-demo-subnet"
}

variable "subnetaddress_prefixes" {
  type        = string
  description = "Subnet network used for all resources. Recommend subnet config /24"
  default     = "10.0.1.0/24"
}

variable "publicip" {
  type        = string
  description = "The public IP assin to the new VM."
  default     = "Cloud-Lab-demo-publicip"
}

variable "publicip_sku" {
  type        = string
  description = "The public IP sku: Default Basic"
  default     = "Basic"
}


variable "nsg" {
  type        = string
  description = "Network Security Group Name used for all resources"
  default     = "Cloud-Lab-demo-nsg"
}

variable "user" {
  type        = string
  description = "User Name to connect on the VM."
  default     = "demo"
}

variable "password" {
  type        = string
  description = "password to connect on the VM."
  default     = "demo@123"
}

variable "location" {
  type        = string
  description = "Azure region used for all resources"
  default = "South Central US"
}