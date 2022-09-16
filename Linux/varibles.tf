variable "resourcegroup" {
  type        = string
  description = "Resource Group used for all resources."
  default     = "demo"
}

variable "size" {
  type        = string
  description = "Virtual Machine size, Default: Standard_DS1_v2"
  default     = "Standard_DS1_v2"
}

variable "storage_account_type" {
  type        = string
  description = "Virtual Machine Disk type, Default: Premium_LRS"
  default     = "Premium_LRS"
}

variable "name" {
  type        = string
  description = "Virtual Machine Name."
  default     = "demoname"
}

variable "nic" {
  type        = string
  description = "Virtual Network Interface Name."
  default     = "demonic"
}

variable "vnet" {
  type        = string
  description = "Virtual network Name used for all resources"
  default     = "demovnet"
}

variable "source_image_reference_publisher" {
  type        = string
  description = "Virtual Machine Publisher, Default: Canonical"
  default     = "Canonical"
}

variable "source_image_reference_offer" {
  type        = string
  description = "Virtual Machine Offer, Default: UbuntuServer"
  default     = "UbuntuServer"
}

variable "source_image_reference_sku" {
  type        = string
  description = "Virtual Machine Sku, Default: 18.04-LTS"
  default     = "18.04-LTS"
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
  default     = "demosubnet"
}

variable "subnetaddress_prefixes" {
  type        = string
  description = "Subnet network used for all resources. Recommend subnet config /24"
  default     = "10.0.1.0/24"
}

variable "publicip" {
  type        = string
  description = "The public IP assin to the new VM."
  default     = "demopublicip"
}

variable "publicip_sku" {
  type        = string
  description = "The public IP sku: Default Basic"
  default     = "Basic"
}


variable "nsg" {
  type        = string
  description = "Network Security Group Name used for all resources"
  default     = "demonsg"
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
  default = "CanadaCentral"
}