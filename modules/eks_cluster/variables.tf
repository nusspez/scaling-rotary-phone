variable "project_name" {
  description = "Nombre del proyecto, usado para etiquetar los recursos."
  type        = string
}

variable "region" {
  description = "Región de AWS donde se desplegará el clúster EKS."
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se desplegará el clúster EKS."
  type        = string
}

variable "private_subnet_ids" {
  description = "Lista de IDs de las subnets PRIVADAS para los nodos del clúster EKS."
  type        = list(string)
}

variable "cluster_version" {
  description = "Versión de Kubernetes para el clúster EKS."
  type        = string
  default     = "1.29" # Verifica la última versión soportada o la que necesites
}

variable "node_group_instance_types" {
  description = "Tipos de instancia para el grupo de nodos."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_desired_size" {
  description = "Número deseado de nodos en el grupo."
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Número mínimo de nodos en el grupo."
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Número máximo de nodos en el grupo."
  type        = number
  default     = 3
}