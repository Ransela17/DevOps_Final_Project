resource "aws_security_group" "lb" {
  
  lifecycle {  
    create_before_destroy = true
  }
  name = "aws_security_group_lb"
  vpc_id = var.vpc_id
  tags = { Name = "${var.environment}-lb-security-group" }
  
  ingress {
    from_port = 80
    to_port = 80
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

resource "aws_lb" "lb" {
  name = "lb"
  load_balancer_type = "application"
  subnets = var.public_subnets[0]
  security_groups = [aws_security_group.lb.id]
    tags = {
      Environment = "production"
  }
}

resource "aws_lb_target_group" "lb_target" {
  name     = "lb-tg"
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id

  health_check {
    path = var.health_path
    port = var.port
  }
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn 	= aws_lb.lb.arn
  port              	= var.port
  protocol          	= "HTTP"

  default_action {
    type             	= "forward"
    target_group_arn 	= aws_lb_target_group.lb_target.arn
  }
}
