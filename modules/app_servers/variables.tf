variable "project_name" {
  description = "Nombre del proyecto para etiquetar los recursos."
  type        = string
}

variable "vpc_id" {
  description = "El ID de la VPC para el grupo de seguridad."
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de las subnets PRIVADAS donde se desplegarán las instancias."
  type        = list(string)
}

variable "instance_type" {
  description = "El tipo de instancia para los servidores de aplicación."
  type        = string
}

variable "key_name" {
  description = "El nombre del Key Pair de EC2 para el acceso SSH a estas instancias."
  type        = string
}

variable "app_port" {
  description = "Puerto en el que escuchará Nginx."
  type        = number
}

# --- Entradas desde otros módulos ---

variable "target_group_arn" {
  description = "ARN del Target Group del ALB para registrar las instancias."
  type        = string
}

variable "alb_security_group_id" {
  description = "ID del grupo de seguridad del ALB para permitirle el acceso."
  type        = string
}

variable "bastion_security_group_id" {
  description = "ID del grupo de seguridad del Bastion para permitirle el acceso SSH."
  type        = string
}