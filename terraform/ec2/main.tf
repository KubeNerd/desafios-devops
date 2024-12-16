terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.78.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# Tentando pegar meu proprio ip adicionando provider http para liberar no nsg
provider "http" {}