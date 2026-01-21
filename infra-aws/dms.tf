resource "aws_dms_replication_instance" "dms-instance" {    
    replication_instance_class = "dms.t3.small"
    replication_instance_id = "migration-dms-instance"
    allocated_storage = 20
    vpc_security_group_ids = [aws_security_group.rds-sg.id]
    replication_subnet_group_id = aws_dms_replication_subnet_group.dms_subnets.id
}

resource "aws_dms_replication_subnet_group" "dms_subnets" {
    replication_subnet_group_description = "DMS Subnet Group"
    replication_subnet_group_id = "dms-subnet-group"
    subnet_ids = [aws_subnet.public-1.id, aws_subnet.public-2.id]
    
    depends_on = [aws_iam_role_policy_attachment.dms-vpc-role-policy]
}
