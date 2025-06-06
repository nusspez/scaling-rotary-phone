variable "project_name" {
  description = "Nombre del proyecto para etiquetar los recursos."
  type        = string
}

variable "vpc_id" {
  description = "El ID de la VPC donde se desplegará el balanceador."
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de las subnets PÚBLICAS donde se colocarán los nodos del balanceador."
  type        = list(string)
}

variable "app_port" {
  description = "El puerto en el que las instancias de la aplicación (Nginx) están escuchando."
  type        = number
  default     = 80
}