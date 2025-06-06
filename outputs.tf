# /outputs.tf (en la raíz de tu proyecto)

# --- Salidas del Módulo VPC ---

output "id_de_la_vpc" {
  description = "El ID de la VPC creada."
  value       = module.vpc.vpc_id
}

output "ids_de_subnets_publicas" {
  description = "La lista de IDs de las subnets públicas creadas."
  value       = module.vpc.public_subnet_ids
}

output "ids_de_subnets_privadas" {
  description = "La lista de IDs de las subnets privadas creadas."
  value       = module.vpc.private_subnet_ids
}


# --- Salidas del Módulo Bastion ---

output "ips_publicas_del_bastion" {
  description = "Las IPs públicas para conectar por SSH a los bastiones."
  value       = module.bastion.bastion_public_ips
}

output "id_grupo_seguridad_bastion" {
  description = "El ID del grupo de seguridad de los bastiones. Útil para otros módulos."
  value       = module.bastion.bastion_security_group_id
}