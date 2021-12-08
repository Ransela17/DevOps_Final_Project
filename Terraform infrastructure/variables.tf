variable "environment" {
  description = "This is mainly used to set various ideintifiers and prefixes/suffixes"
  default = "workshop-production"
}

variable "region" {
  type = string
  default = "eu-west-1"
  description = "AWS region where our resources going to create choose"
}

variable "azs" { 
  description = "VPC availability zones"
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "vpc_cidr" {
  type =  string
  description = "IP prefix of main vpc"
  default = "172.18.0.0/18"
}

variable "private_subnets" {
  description = "IP prefix of private (vpc only routing) subnets"
  default = ["172.18.0.0/20","172.18.16.0/20"]  
  
}

variable "public_subnets" {
  description = "IP prefix of public (internet gw route) subnet"
  default = ["172.18.32.0/20"  , "172.18.48.0/20"]
}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default = true
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default = true
}

variable "db_name" {
  default		= "rds_db"
}

variable "db_port" {
  default		= 3306
}

variable "db_username" {
  default		= "username"
}


variable "terraform_bucket" {
  default = "workshop-tf-state"
  description = <<EOS
S3 bucket with the remote state of the site module.
The site module is a required dependency of this module
EOS

}

variable "site_module_state_path" {
  default = "workshop-site-state/terraform.tfstate"
  description = <<EOS
S3 path to the remote state of the site module.
The site module is a required dependency of this module
EOS

}
variable "db_password" {
  default		= "password"
}

variable "instance_type" {
  description = "instance type for workshop-app instances"
  default = "t2.micro"
}

variable "ami" {
  description = "ami id for workshop-app instances - Ubuntu Server 18.04"
  default = "ami-095b735dce49535b5"
}

variable "role" {
	default = "workshop-app-wrapper"
}

variable "cluster_name" {
	default = "workshop-terraform"
}
variable "asg_min_size" {
  default = 2
}

variable "asg_desired_capacity" {
  default = 2
}

variable "asg_max_size" {
  default = 4
}

variable "policy_adjustment_type"{
  default = "ChangeInCapacity"
}

variable "cooldown_sec"{
  default = 300
}
