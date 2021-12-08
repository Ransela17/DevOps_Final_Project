variable "environment" {}
variable "vpc_id" {}

variable "vpc_cidr" {}

variable "azs" {}

variable "private_subnets" {}

variable "public_subnets" {}

variable "port" {
  default = 80
}

variable "protocol" {
  default = "HTTP"
}

variable "health_path" {
  default = "/"
}

variable "multi_az" {
  default = false
}


