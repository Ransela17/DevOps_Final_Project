output "rds-db" {
  value = [ aws_db_instance.rds-db.id ]
}

output "db_subnet_group" {
  value = [ aws_db_subnet_group.rds-db-default-group.subnet_ids ]
}

output "rds_security_group" {
  value = [ aws_security_group.rds-psql-db.id ]
}

output "rds_hostname" {
  value = aws_db_instance.rds-db.address
}

output "rds_db_name" {
  value = aws_db_instance.rds-db.name 
}


output "rds_port" {
  value = aws_db_instance.rds-db.port
}

output "rds_username" {
  value = aws_db_instance.rds-db.username
}

output "rds_password" {
  value = aws_db_instance.rds-db.password
}