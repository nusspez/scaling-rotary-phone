# /main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "REPLACE_ME" # <-- No olvides reemplazar esto

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "aws" {
  region = var.region
}


# --- 1. Crear VPC ---
module "vpc" {
  source = "./modules/VPC" # Usando 'VPC' en mayúsculas como en tu archivo

  # Todas las configuraciones ahora vienen de variables
  project_name         = var.project_name
  region               = var.region
  availability_zones   = var.availability_zones
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# --- 2. Crear Servidores Bastion ---


# --- 3. Crear Balanceador de Carga (próximo paso) ---


# --- 4. Crear Servidores de Aplicación (próximo paso) ---
