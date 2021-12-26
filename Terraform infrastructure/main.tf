
// define an s3 backend here
terraform {
  backend "s3" {
    bucket                = "migo-terraform"
    key                   = "workshop-site-state/terraform.tfstate"
    region                = "eu-west-1"
    encrypt               = true
    dynamodb_table        = "tf-workshop-site-locks"
  }
}

provider "aws" {
  region                  = var.region
}

module "vpc" {
  source = "./modules/vpc"
  environment             = var.environment
  vpc_cidr                = var.vpc_cidr
  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets

  //multiple azs neede to avoid an error in when applyin aws_db_subnet_group.default-subnet-group
  azs                     =  var.azs
  enable_dns_support      = var.enable_dns_support
  enable_dns_hostnames    = var.enable_dns_hostnames

}

module "database" {
  source = "./modules/db-psql"
  environment             = var.environment
  azs 							 		  = var.azs
  private_subnets 				= module.vpc.private_subnets[0]
  vpc_id 								  = module.vpc.vpc_id
  password 								= var.db_password
  username 								= var.db_username
  port 								    = var.db_port
  name 								    = var.db_name
  
  depends_on              = [module.vpc]
  site_module_state_path = {}
  terraform_bucket =  {}
}

module "alb" {
  source = "./modules/load-balancer"
  
  public_subnets 				  = module.vpc.public_subnets
  private_subnets         = module.vpc.private_subnets
  vpc_id 								  = module.vpc.vpc_id
  vpc_cidr                = var.vpc_cidr 
  environment 					  = var.environment
  azs                     = var.azs
  
  depends_on              = [module.database]
}

module "ec2" {
  source = "./modules/ec2"
  
  public_subnets 						= module.vpc.public_subnets
  vpc_id 								    = module.vpc.vpc_id
  azs                       =  var.azs
  //db_hostname							  = module.database.rds_hostname
  //db_port 								  = module.database.rds_port
  //db_username 							= module.database.rds_username
  //db_password 							= module.database.rds_password
  //target_group_arn 					= module.alb.target_group_arn
  //alb_arn_suffix            = module.alb.alb_arn_suffix 
  asg_min_size 		         	= var.asg_min_size
  asg_max_size 		        	= var.asg_max_size
  asg_desired_capacity 	    = var.asg_desired_capacity
  instance_type 						= var.instance_type
  ami 								    	= var.ami
  environment 							= var.environment
  cluster_name              = var.cluster_name
  role                      = {}
  depends_on = [module.alb]
} 