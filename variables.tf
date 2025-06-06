# --- Variables Generales del Proyecto ---
variable "project_name" {
  description = "Nombre base para todos los recursos."
  type        = string
  default     = "mi-app-produccion"
}

variable "region" {
  description = "Región de AWS para el despliegue."
  type        = string
  default     = "us-west-2"
}

# --- Variables de Red (VPC) ---
variable "availability_zones" {
  description = "Lista de Zonas de Disponibilidad para el despliegue."
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "vpc_cidr_block" {
  description = "Bloque CIDR principal para la VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de bloques CIDR para las subnets públicas."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Lista de bloques CIDR para las subnets privadas."
  type        = list(string)
  default     = ["10.20.101.0/24", "10.20.102.0/24"]
}


# --- Variables del Módulo Bastion ---
variable "bastion_instance_type" {
  description = "Tipo de instancia para los bastiones."
  type        = string
  default     = "t3.small" # <- Requisito
}

variable "bastion_key_name" {
  description = "key name"
  default = "key-omar"
  type        = string
}

variable "bastion_allowed_ssh_cidr" {
  description = "Lista de IPs en formato CIDR que pueden acceder por SSH a los bastiones."
  type        = list(string)
  default     = ["0.0.0.0/0"] # ADVERTENCIA: Permite CUALQUIER IP. Debe ser sobreescrito.
}