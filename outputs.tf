# /outputs.tf

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

