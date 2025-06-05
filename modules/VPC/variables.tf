variable "project_name" {
  description = "Nombre del proyecto, usado para etiquetar los recursos."
  type        = string
  default     = "mi-proyecto"
}

variable "region" {
  description = "Región de AWS donde se desplegarán los recursos."
  type        = string
  default     = "us-west-2" # 
}

variable "vpc_cidr_block" {
  description = "Bloque CIDR principal para la VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Lista de Zonas de Disponibilidad para desplegar las subnets."
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"] 
}

variable "public_subnet_cidrs" {
  description = "Lista de bloques CIDR para las subnets públicas. Debe haber uno por cada AZ."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Lista de bloques CIDR para las subnets privadas. Debe haber uno por cada AZ."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}