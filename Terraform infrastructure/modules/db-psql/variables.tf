variable "environment" {}

variable "vpc_id" {}

variable "azs" {}

variable "private_subnets" {}

variable "skip_final_snapshot" {
  default = true
}

variable "terraform_bucket" {}

variable "site_module_state_path" {}

variable "multi_az" {
  default = false
}

variable "apply_immediately" {
  default = true
}

variable "publicly_accessible" {
  default = true
}

variable "engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "11.10"
}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "name" {
  default = "workshopDB"
}

variable "storage_type" {
  default = "standard"
}

variable "allocated_storage" {
  default = 20
}

variable "port" {
  default = 5432
}

variable "username" {}

variable "password" {}

