resource "aws_vpc" "main-vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "vpc-migracion" }
}

resource "aws_subnet" "public-1" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "nixos-public-subnet-1" }
}
resource "aws_subnet" "public-2" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "nixos-public-subnet-2" }
}

resource "aws_subnet" "private-1" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "172.16.3.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags              = { Name = "db-private-subnet-1" }
}

resource "aws_subnet" "private-2" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "172.16.4.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
  tags              = { Name = "db-private-subnet-2" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags   = { Name = "main-igw" }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "pub-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "10.100.0.0/24"
    network_interface_id = aws_instance.nixos_server.primary_network_interface_id
  }
  tags = {Name = "private route table"}
}

resource "aws_route_table_association" "priv-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private-rt.id
}