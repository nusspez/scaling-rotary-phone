# --- 1. Grupo de Seguridad para los Bastiones ---
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Permite acceso SSH al Bastion Host"
  vpc_id      = var.vpc_id

  # Regla de entrada: Permitir SSH (puerto 22) solo desde la IP especificada.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # Regla de salida: Permitir todo el tráfico saliente.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

# --- 2. Instancias EC2 para los Bastiones ---
# Se creará una instancia en cada subnet pública proporcionada.
resource "aws_instance" "bastion" {
  count = length(var.subnet_ids)

  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true # Necesitamos una IP pública para acceder desde internet

  tags = {
    Name = "${var.project_name}-bastion-${count.index + 1}"
  }
}