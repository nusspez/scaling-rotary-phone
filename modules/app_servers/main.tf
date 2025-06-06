# --- 1. Grupo de Seguridad para los Servidores de Aplicación ---
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Permite trafico desde el ALB y SSH desde el Bastion"
  vpc_id      = var.vpc_id

  # Regla de entrada: Permitir tráfico en el puerto de la app SOLO desde el ALB.
  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  # Regla de entrada: Permitir SSH SOLO desde el Bastion.
  ingress {
    from_port       = 2444 # <-- CAMBIO: Puerto actualizado a 2444
    to_port         = 2444 # <-- CAMBIO: Puerto actualizado a 2444
    protocol        = "tcp"
    security_groups = [var.bastion_security_group_id]
  }

  # Regla de salida: Permitir todo el tráfico saliente.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

# --- 2. Plantilla de Lanzamiento (Launch Template) ---
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-"
  image_id      = data.aws_ami.ubuntu.id # <-- CAMBIO: Usa la AMI de Ubuntu encontrada abajo
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.app.id]

  # CAMBIO: Script actualizado para instalar Nginx en Ubuntu y crear un HTML personalizado.
  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
              echo "<h1>Hello from instance: $INSTANCE_ID</h1>" > /var/www/html/index.html
              EOF
  )

  tags = {
    Name = "${var.project_name}-app-instance"
  }
}

# --- 3. Auto Scaling Group (ASG) ---
# (Sin cambios en este recurso)
resource "aws_autoscaling_group" "app" {
  name_prefix      = "${var.project_name}-asg-"
  desired_capacity = 2
  min_size         = 1
  max_size         = 3

  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app-instance"
    propagate_at_launch = true
  }
}

# --- CAMBIO: Data Source para encontrar la última AMI de Ubuntu 22.04 ---
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # ID Canónico de Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}