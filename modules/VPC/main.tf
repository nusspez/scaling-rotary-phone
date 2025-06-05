# --- 1. Creación de la VPC Principal ---
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# --- 2. Creación de Subnets (Públicas y Privadas) en cada Zona de Disponibilidad ---
resource "aws_subnet" "public" {
  # Usamos 'count' para crear una subnet por cada CIDR en la lista de variables
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true # Importante para que recursos como el Bastion obtengan IP pública

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

# --- 3. Configuración de la Salida a Internet (Internet Gateway y NAT Gateways) ---
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Creamos una IP Elástica para cada NAT Gateway
resource "aws_eip" "nat" {
  count      = length(var.public_subnet_cidrs)
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  }
}

# Creamos un NAT Gateway en cada subnet pública para dar salida a las privadas
resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-nat-gw-${count.index + 1}"
  }
}

# --- 4. Configuración del Enrutamiento ---
# Tabla de rutas para las subnets PÚBLICAS
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    # Ruta hacia internet a través del Internet Gateway
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Asociamos la tabla de rutas pública a CADA subnet pública
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Tablas de rutas para las subnets PRIVADAS (una por cada AZ)
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    # Ruta hacia internet a través del NAT Gateway correspondiente
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  }
}

# Asociamos cada tabla de rutas privada a SU subnet privada correspondiente
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}