variable "cluster_name" {
  description = "Nombre del clúster EKS."
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint del servidor API del clúster EKS."
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "Datos de la autoridad de certificación del clúster EKS."
  type        = string
}