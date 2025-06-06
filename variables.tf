variable "vm_names" {
  description = "Lista de nomes para as VMs"
  type        = list(string)
  default     = ["tsprdad02", "tsprdeid02"]
}

variable "vm_count" {
  description = "Número de VMs a serem criadas"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Tamanho da VM"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Nome de usuário administrador"
  type        = string
}

variable "admin_password" {
  description = "Senha do administrador"
  type        = string
  sensitive   = true
}

variable "os_disk_type" {
  description = "Tipo de disco do SO"
  type        = string
  default     = "StandardSSD_LRS"
}

# Imagem Windows Server
variable "image_publisher" {
  description = "Publicador da imagem"
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "image_offer" {
  description = "Oferta da imagem"
  type        = string
  default     = "WindowsServer"
}

variable "image_sku" {
  description = "SKU da imagem"
  type        = string
  default     = "2019-Datacenter"
}

variable "image_version" {
  description = "Versão da imagem"
  type        = string
  default     = "latest"
}

variable "subnet_name" {
  description = "Nome da Subnet existente"
  type        = string
  default     = "Identity"
}

variable "vnet_name" {
  description = "Nome da VNET existente"
  type        = string
  default     = "PRD"
}

variable "nsg_name" {
  description = "Nome do NSG existente"
  type        = string
  default     = "NSG-PRD"
}

variable "resource_group_name" {
  description = "Nome do Resource Group existente"
  type        = string
  default     = "RG02"
}

# variables.tf
variable "environment" {
  type    = string
  default = "prod"
}