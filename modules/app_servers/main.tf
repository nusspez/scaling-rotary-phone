# --- 1. Grupo de Seguridad para los Servidores de Aplicación ---
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Permite tráfico desde el ALB y SSH desde el Bastion"
  vpc_id      = var.vpc_id

  # Regla de entrada: Permitir tráfico en el puerto de la app SOLO desde el ALB.
  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id] # <-- Conexión con el módulo ALB
  }

  # Regla de entrada: Permitir SSH (puerto 22) SOLO desde el Bastion.
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_security_group_id] # <-- Conexión con el módulo Bastion
  }

  # Regla de salida: Permitir todo el tráfico saliente (para actualizaciones vía NAT Gateway).
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
# Define la configuración de las instancias que creará el Auto Scaling Group.
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-"
  image_id      = data.aws_ami.amazon_linux_2.id # Usa la AMI de Amazon Linux 2 encontrada abajo
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.app.id]

  # Script que se ejecuta al iniciar cada instancia para instalar y arrancar Nginx
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl start nginx
              systemctl enable nginx
              EOF
  )

  tags = {
    Name = "${var.project_name}-app-instance"
  }
}

# --- 3. Auto Scaling Group (ASG) ---
# Gestiona el ciclo de vida de las instancias.
resource "aws_autoscaling_group" "app" {
  name_prefix = "${var.project_name}-asg-"
  
  # Tamaño del grupo
  desired_capacity = 2
  min_size         = 1
  max_size         = 3

  vpc_zone_identifier = var.subnet_ids # Las subnets PRIVADAS donde se lanzarán

  # Conexión con el Launch Template
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # Conexión con el Load Balancer
  target_group_arns = [var.target_group_arn]

  # Etiqueta las instancias que crea
  tag {
    key                 = "Name"
    value               = "${var.project_name}-app-instance"
    propagate_at_launch = true
  }
}

# --- Data Source para encontrar la última AMI de Amazon Linux 2 ---
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}