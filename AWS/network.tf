# Criação da VPC
# La red principal 
resource "aws_vpc" "vpc_main" {
  cidr_block = "10.0.0.0/16"
  # habilita los DNS para la VPC
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_main"
  }
}

# Criação da Subnet Pública
# Esta red puede tener acceso a internet
# se puede utilizar para red privada tambien
resource "aws_subnet" "public_subnet" {
  # aws_vpc.vpc_main.id es la red principal
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = "10.0.5.0/24"

  tags = {
    Name = "public_subnet"
  }
}

# Criação do Internet Gateway
# sin este, la sub red publica no puede acceder a internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "igw"
  }
}

# Criação da Tabela de Roteamento
# todas las redes que estan dentro de la VPC pueden acceder a internet
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt"
  }
}

# Criação da Rota Default para Acesso à Internet
resource "aws_route" "routetointernet" {
  route_table_id            = aws_route_table.rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}

# Associação da Subnet Pública com a Tabela de Roteamento
resource "aws_route_table_association" "pub_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt.id
}


