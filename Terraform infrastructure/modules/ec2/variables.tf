variable "environment" {}

variable "private_subnets" {}

variable "azs" {}

variable "vpc_id" {}

variable "instance_type" {}

variable "ami" {}

variable "target_group_arn" {}

variable "role" {}

variable "cluster_name" {}

variable "asg_min_size" {}

variable "asg_desired_capacity" {}

variable "asg_max_size" {}

variable "additional_sgs" {
  default = ""
}
variable web-app {
  default = "web-app"
} 
variable "policy_adjustment_type"{
  default = "ChangeInCapacity"
}

variable "cooldown_sec"{
  default = 300
}

variable "key_pair_name" {}

variable "db_host" {}
variable "db_password" {}
variable "db_user" {}
variable "db_name" {}