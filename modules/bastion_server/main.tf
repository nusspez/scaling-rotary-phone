# modules/bastion/main.tf

# NUEVO: Busca automáticamente la AMI más reciente de Ubuntu 22.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # ID Canónico de la cuenta de Canonical (dueños de Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- 1. Grupo de Seguridad para los Bastiones ---
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Permite acceso SSH al Bastion Host"
  vpc_id      = var.vpc_id

  # Regla de entrada: Permitir SSH solo desde la IP especificada
  ingress {
    from_port   = 2422 # <-- CAMBIO: Puerto actualizado a 2422
    to_port     = 2422 # <-- CAMBIO: Puerto actualizado a 2422
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
resource "aws_instance" "bastion" {
  count = length(var.subnet_ids)

  # Usa la AMI encontrada o la especificada en las variables
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.bastion.id]
  # CAMBIO: Se elimina 'associate_public_ip_address', ahora se gestiona con EIP

  tags = {
    Name = "${var.project_name}-bastion-${count.index + 1}"
  }
}

# --- 3. IP Elástica para cada Bastion ---
resource "aws_eip" "bastion" {
  count    = length(var.subnet_ids)
  instance = aws_instance.bastion[count.index].id
  tags = {
    Name = "${var.project_name}-bastion-eip-${count.index + 1}"
  }
}