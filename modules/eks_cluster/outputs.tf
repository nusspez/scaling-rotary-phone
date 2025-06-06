output "cluster_name" {
  description = "El nombre del clúster EKS."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "El endpoint del servidor API del clúster EKS."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Datos de la autoridad de certificación del clúster EKS (codificados en base64)."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_oidc_issuer_url" {
  description = "La URL del proveedor OIDC del clúster. Útil para IAM Roles for Service Accounts (IRSA)."
  value       = module.eks.cluster_oidc_issuer_url
}

output "eks_managed_node_groups_iam_role_arn" {
  description = "ARN del rol IAM para los grupos de nodos gestionados por EKS."
  value       = module.eks.eks_managed_node_groups_iam_role_arns["main_nodes"] # Ajusta "main_nodes" si cambiaste el nombre
}