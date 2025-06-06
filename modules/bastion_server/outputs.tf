output "bastion_public_ips" {
  description = "Lista de las IPs Elásticas públicas de los Bastion Hosts creados."
  value       = aws_eip.bastion.*.public_ip 
}

output "bastion_security_group_id" {
  description = "El ID del grupo de seguridad de los bastiones."
  value       = aws_security_group.bastion.id
}