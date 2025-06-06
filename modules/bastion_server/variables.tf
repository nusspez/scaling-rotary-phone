variable "project_name" {
  description = "Nombre del proyecto para etiquetar los recursos."
  type        = string
}

variable "vpc_id" {
  description = "El ID de la VPC donde se crearán los bastiones."
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de las subnets PÚBLICAS donde se desplegará un bastion en cada una."
  type        = list(string)
}

variable "instance_type" {
  description = "El tipo de instancia para los bastiones."
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "El ID de la AMI para los bastiones (ej. Amazon Linux 2)."
  type        = string
  # Nota: Es buena práctica buscar el AMI más reciente para tu región.
  # Para us-west-2 (Oregon) puedes usar 'ami-03f65b8614a860a5b' o buscar uno nuevo.
}

variable "key_name" {
  description = "El nombre del Key Pair de EC2 para permitir el acceso SSH."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Bloque CIDR de la IP desde la cual se permitirá el acceso SSH. ¡Debe ser tu IP pública!"
  type        = list(string)
  default     = ["0.0.0.0/0"] # ADVERTENCIA: Esto permite acceso desde CUALQUIER IP. Cámbialo por tu IP.
}