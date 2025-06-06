# /main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
module "bastion" {
  source = "./modules/bastion_server"

  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnet_ids

  # --- Usando las nuevas variables raíz ---
  instance_type    = var.bastion_instance_type # <-- CAMBIO
  key_name         = var.bastion_key_name
  allowed_ssh_cidr = var.bastion_allowed_ssh_cidr
}
# --- 3. Crear Balanceador de Carga (próximo paso) ---

# --- 3. Crear Balanceador de Carga ---
module "load_balancer" {
  source = "./modules/load_balancer"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids # El ALB se despliega en las subnets públicas
  app_port     = var.app_port
}

# --- 4. Crear Servidores de Aplicación (próximo paso) ---
module "app_servers" {
  source = "./modules/app_servers"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids # <-- Desplegados en subnets privadas
  instance_type     = var.app_server_instance_type
  key_name          = var.app_server_key_name
  app_port          = var.app_port

  # --- Conectando todas las piezas ---
  target_group_arn          = module.load_balancer.target_group_arn
  alb_security_group_id     = module.load_balancer.alb_security_group_id
  bastion_security_group_id = module.bastion.bastion_security_group_id
}


# --- 5. Crear Clúster EKS ---
module "eks_cluster" {
  source = "./modules/eks_cluster"

  project_name = var.project_name
  region       = var.region
  vpc_id       = module.vpc.vpc_id
  # Importante: Los nodos EKS deben ir en subnets que tengan acceso a internet
  # vía NAT Gateway si son privadas, o que sean públicas si no usas NAT para ellos.
  # Para este ejemplo, usaremos las subnets privadas que ya tienen NAT.
  private_subnet_ids = module.vpc.private_subnet_ids

  cluster_version             = var.eks_cluster_version
  node_group_instance_types   = var.eks_node_group_instance_types
  node_group_desired_size     = var.eks_node_group_desired_size
  # node_group_min_size y node_group_max_size usarán los defaults del módulo eks_cluster
}