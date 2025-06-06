# --- 1. Grupo de Seguridad para el Balanceador de Carga ---
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Permite trafico web entrante al ALB"
  vpc_id      = var.vpc_id

  # Regla de entrada: Permitir HTTP desde cualquier lugar
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de salida: Permitir todo el tráfico saliente hacia la VPC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# --- 2. El Balanceador de Carga (ALB) ---
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false # Es público (internet-facing)
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# --- 3. El Grupo de Destino (Target Group) ---
# Aquí es donde se registrarán nuestras instancias Nginx más adelante.
resource "aws_lb_target_group" "main" {
  name     = "${var.project_name}-tg"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # Configuración de los chequeos de salud
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200" # Espera un código de respuesta HTTP 200
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

# --- 4. El Oyente (Listener) ---
# Conecta el tráfico entrante del puerto 80 del ALB al Target Group.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
