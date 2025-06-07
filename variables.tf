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

# --- Variables del Módulo de App ---
variable "app_port" {
  description = "Puerto en el que escuchan los servidores Nginx."
  type        = number
  default     = 80
}

# --- Variables del Módulo de load balancer---
variable "app_server_key_name" {
  description = "key name"
  default = "key-omar"
  type        = string
}

# --- Variables del Módulo App Servers ---
variable "app_server_instance_type" {
  description = "Tipo de instancia para los servidores de aplicación."
  type        = string
  default     = "t3.small" # <-- CAMBIO: Actualizado al valor requerido
}

# --- Variables del Módulo EKS Cluster ---
variable "eks_cluster_version" {
  description = "Versión de Kubernetes para el clúster EKS."
  type        = string
  default     = "1.29"
}

variable "eks_node_group_instance_types" {
  description = "Tipos de instancia para el grupo de nodos de EKS."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_group_desired_size" {
  description = "Número deseado de nodos en el grupo de EKS."
  type        = number
  default     = 2
}

variable "eks_node_group_min_size" { # <--- ¡NUEVA VARIABLE!
  description = "Tamaño mínimo de los nodos en el grupo de EKS."
  type        = number
  default     = 1
}

variable "eks_node_group_max_size" { # <--- ¡NUEVA VARIABLE!
  description = "Tamaño máximo de los nodos en el grupo de EKS."
  type        = number
  default     = 3
}