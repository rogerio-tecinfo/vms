terraform {
  required_version = ">= 1.3.7"

  backend "azurerm" {
    resource_group_name  = "RG02"                    # Nome do Resource Group que tem o Storage Account
    storage_account_name = "restorevmrg02"           # Nome do Storage Account (sem caixa alta)
    container_name       = "tfstate"                 # Nome do container no Blob Storage
    key                  = "prod.tfstate"            # Nome do arquivo .tfstate que será salvo
    #use_azuread_auth     = true                      # Critical for service principal auth
  }
}
