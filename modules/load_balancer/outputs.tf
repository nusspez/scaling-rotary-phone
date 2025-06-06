output "alb_dns_name" {
  description = "El nombre DNS público del balanceador de carga."
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "El ARN del grupo de destino. Necesario para registrar las instancias de la app."
  value       = aws_lb_target_group.main.arn
}

output "alb_security_group_id" {
  description = "El ID del grupo de seguridad del ALB. Necesario para permitir tráfico desde el ALB a las instancias."
  value       = aws_security_group.alb.id
}