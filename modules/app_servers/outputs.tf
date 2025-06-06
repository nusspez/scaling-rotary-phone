output "autoscaling_group_name" {
  description = "El nombre del Auto Scaling Group creado."
  value       = aws_autoscaling_group.app.name
}