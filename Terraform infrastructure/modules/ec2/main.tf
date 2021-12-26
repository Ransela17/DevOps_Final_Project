data "template_file" "user_data" {
  template = file("${path.module}/templates/project-app.cloudinit")

  vars = {
    DB_HOST = var.db_host,
    DB_PASSWORD = var.db_password,
    DB_USER = var.db_user,
    DB_NAME = var.db_name
  }
}

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

data "aws_iam_policy_document" "ec2_instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.environment}-ec2-instance"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_instance_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name       = "${var.environment}-ec2-instances"
  path       = "/"
  role       = aws_iam_role.ec2_instance_role.id
}

# Render a part using a `template_file`
resource "aws_launch_configuration" "workshop-app_lc" {
  user_data =  data.template_file.user_data.rendered
   lifecycle {  # This is necessary to make terraform launch configurations work with autoscaling groups
    create_before_destroy = true
  }
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.id
  security_groups = [aws_security_group.ec2.id]
  name_prefix = "${var.cluster_name}_lc"
  enable_monitoring = false
  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.key_pair_name
}

resource "aws_autoscaling_group" "workshop-app_asg" {
  name = "${var.cluster_name}_asg"
  min_size = var.asg_min_size
  max_size = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  launch_configuration = aws_launch_configuration.workshop-app_lc.name
  vpc_zone_identifier = var.private_subnets
  target_group_arns     = [var.target_group_arn]

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
