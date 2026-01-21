resource "aws_security_group" "rds-sg" {
  name        = "rds-security-group"
  description = "Permitir trafico MySQL"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.100.0.0/24", "172.16.0.0/16"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion" {
  name        = "nixos-ssh-access"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow MySQL traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.100.0.0/24", "172.16.0.0/16"]
  }

  ingress {
    description = "Allow WireGuard VPN"
    from_port = 51820
    to_port = 51820
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    description = "Allow all traffic from WireGuard VPN"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.100.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nixos-ssh-sg"
  }
}
