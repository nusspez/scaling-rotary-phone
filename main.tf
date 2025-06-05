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
    organization = "REPLACE_ME"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}


# --- 1. Create VPC ---

module "vpc" {
  source = "./modules/VPC" # Ruta a la carpeta del módulo

  # --- Pasando las variables específicas para us-west-2 ---
  project_name         = "mi-app-produccion"
  region               = "us-west-2"
  availability_zones   = ["us-west-2a", "us-west-2b"]
  
  # Los CIDR pueden ser los mismos o puedes ajustarlos si lo necesitas
  vpc_cidr_block       = "10.20.0.0/16" 
  public_subnet_cidrs  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnet_cidrs = ["10.20.101.0/24", "10.20.102.0/24"]
}


output "id_de_la_vpc" {
  description = "El ID de la VPC creada en us-west-2."
  value       = module.vpc.vpc_id
}

output "ids_de_subnets_publicas" {
  description = "La lista de IDs de las subnets públicas creadas."
  value       = module.vpc.public_subnet_ids
}

output "ids_de_subnets_privadas" {
  description = "La lista de IDs de las subnets privadas creadas."
  value       = module.vpc.private_subnet_ids
}

# --- 2. Create Bastion Servers ---



# --- 3. Create Load Balancer ---


# --- 4. Create app servers ---

