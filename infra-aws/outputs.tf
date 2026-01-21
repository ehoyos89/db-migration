
output "public_ip" {
    description = "Public ip of the bastion host"
    value = aws_instance.nixos_server.public_ip
}
  
output "rds_endpoint" {
    description = "Endpoint of the RDS instance"
    value = aws_db_instance.mysql-dest.address

}

output "rds_port" {
    description = "Port of the RDS instance"
    value = aws_db_instance.mysql-dest.port
}

output "private_ip" {
    description = "Private ip of the bastion host"
    value = aws_instance.nixos_server.private_ip
}

output "dms_replication_instance_arn" {
    description = "ARN of the DMS replication instance"
    value = aws_dms_replication_instance.dms-instance.replication_instance_arn
}
  
output "dms_replication_instance_public_ips" {
  description = "IPs de la instancia de replicación (útil para revisar SGs)"
  value       = aws_dms_replication_instance.dms-instance.replication_instance_public_ips
}
  

