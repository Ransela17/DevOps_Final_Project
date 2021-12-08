resource "aws_security_group" "rds-mysql-db" {
  name = "workshop_rds"
  description = "sg for workshop rds"
  vpc_id = var.vpc_id


  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds-db-default-group" {
  name       			= "rds-db-subnet"
  subnet_ids 			= var.private_subnets
  description = "Subnet for Database Instance"
  tags 					= { Name = "${var.environment}-subnet-group" }
}

resource "aws_db_instance" "rds-db" {
  allocated_storage    	= var.allocated_storage
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  name                  = var.name
  port                  = var.port
  username              = var.username
  password              = var.password
  skip_final_snapshot   = var.skip_final_snapshot
  multi_az			        = var.multi_az
  apply_immediately	    = var.apply_immediately
  publicly_accessible   = var.publicly_accessible
  storage_type		      = var.storage_type
  db_subnet_group_name  = aws_db_subnet_group.rds-db-default-group.name
  availability_zone     = var.azs[0]
  vpc_security_group_ids = [ aws_security_group.rds-mysql-db.id ]
  
  tags 					= { Name = "${var.environment}-db_instance" }
}