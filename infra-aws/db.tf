resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "rds-subnets"
  subnet_ids = [aws_subnet.private-1.id, aws_subnet.private-2.id]
}

resource "aws_db_instance" "mysql-dest" {
  allocated_storage      = 20
  db_name                = "ecommerce_dest"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro" # Free Tier
  username               = "" # Usa variables para esto
  password               = "" # Usa variables para esto
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot    = true
  
  # Seguridad solicitada
  storage_encrypted      = true
  backup_retention_period = 7
}