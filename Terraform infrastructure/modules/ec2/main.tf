resource "aws_security_group" "ec2" {
  
  lifecycle {  
    create_before_destroy = true
  }

  name = "aws_security_group_ec2"
  vpc_id = var.vpc_id
  description = "${var.cluster_name}-ec2"
  tags = { Name = "${var.environment}-ec2-security-group" }
  
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
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

resource "aws_launch_configuration" "workshop-app_lc" {
  user_data =  file("${path.module}/templates/project-app.cloudinit")
   lifecycle {  # This is necessary to make terraform launch configurations work with autoscaling groups
    create_before_destroy = true
  }
  security_groups = [aws_security_group.ec2.id]
  name = "${var.cluster_name}_lc"
  enable_monitoring = false
  image_id = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.admin_key.key_name
  
}

resource "aws_autoscaling_group" "workshop-app_asg" {
  name = "${var.cluster_name}_asg"
  min_size = var.asg_min_size
  max_size = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  launch_configuration = aws_launch_configuration.workshop-app_lc.name
  vpc_zone_identifier = var.public_subnets[0]

  tag {
    key = "Name"
    value = var.cluster_name
    propagate_at_launch = true
  }

  tag {
    key = "Team"
    value = "Workshop"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "admin_key" {
  key_name 				  = var.environment
  public_key 			  = file("${path.module}/keys/admin.pub")
  tags 					  = { Name = "${var.environment}-key_pair" }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.environment}-scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = var.policy_adjustment_type
  cooldown               = var.cooldown_sec
  autoscaling_group_name = aws_autoscaling_group.workshop-app_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.environment}-scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = var.policy_adjustment_type
  cooldown               = var.cooldown_sec
  autoscaling_group_name = aws_autoscaling_group.workshop-app_asg.name
}
  
  
  

/*
  # Render a part using a `template_file`
data "template_file" "script" {
  template = file("${path.module}/templates/project-app.cloudinit")

  vars = {
	  MASTER_IP=var.master_ip
    VAULT_TOKEN=var.vault_token
	  DB_DNS=var.db_hostname
	  DB_PORT=var.db_port
	  DB_USER=var.db_username
	  DB_PASS=var.db_password
  }
}

*/