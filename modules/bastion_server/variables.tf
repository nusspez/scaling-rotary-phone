# modules/bastion/variables.tf

variable "project_name" {
  description = "Nombre del proyecto para etiquetar los recursos."
  type        = string
}

variable "vpc_id" {
  description = "El ID de la VPC donde se crearán los bastiones."
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de las subnets PÚBLICAS donde se desplegará un bastion en cada una."
  type        = list(string)
}

variable "instance_type" {
  description = "El tipo de instancia para los bastiones."
  type        = string
  default     = "t3.small" # <- Valor por defecto actualizado
}

variable "ami_id" {
  description = "Opcional: ID de la AMI a usar. Si se deja en blanco, se buscará la última de Ubuntu 22.04."
  type        = string
  default     = "" # <- Se deja en blanco para usar la búsqueda automática
}

variable "key_name" {
  description = "El nombre del Key Pair de EC2 para permitir el acceso SSH."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Bloque CIDR de la IP desde la cual se permitirá el acceso SSH."
  type        = list(string)
}