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

module "./modules/bastion_server" {
  source       = "./modules/bastion"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids

  # --- Usando las nuevas variables raíz ---
  ami_id           = var.bastion_ami_id
  key_name         = var.bastion_key_name
  allowed_ssh_cidr = var.bastion_allowed_ssh_cidr
}


# --- 3. Crear Balanceador de Carga (próximo paso) ---


# --- 4. Crear Servidores de Aplicación (próximo paso) ---
