output "admin_key_name" {
  value = aws_ke
}

output "aws_launch_config_id" {
  value = aws_launch_configuration.workshop-app_lc.id
}

output "aws_autoscaling_group_id" {
  value = aws_autoscaling_group.workshop-app_asg.id
}

output "aws_security_group_ec2" {
  value = aws_security_group.ec2.id
}

