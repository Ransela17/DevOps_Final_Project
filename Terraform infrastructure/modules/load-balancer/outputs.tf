output "alb_security_group" {
  value = [ aws_security_group.lb.id ]
}

output "alb_id" {
  value = [ aws_lb.lb.id ]
}

output "alb_dns_name" {
  value = aws_lb.lb.dns_name 
}

output "target_group_arn" {
  value = aws_lb_target_group.lb_target.arn
}

output "alb_arn_suffix" {
  value = aws_lb.lb.arn_suffix
}
