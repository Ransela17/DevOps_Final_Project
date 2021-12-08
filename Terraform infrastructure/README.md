# Terraform Infrastructur

This repo creates environment modules with all the necessary resources to enable end-to-end interaction with a Web-app include VPC, RDS, Load-Balancer and EC2 on AWS

## What are we provisioning here?

- Creating S3 bucket and DynamoDb - for state files 
- VPC and Gateway resources
- Subnets
- Security groups
- Load-Balancer
- Autoscaling Group
- LaunchConfiguration (and a user-data script included)
- an admin RSA public key (for SSH connection to the instances)

## EC2 ##

WORKSHOP APP
create a web-application(apache2 server) cluster on EC2 instances. We like to autoscale the cluster with an Autoscaling group, with 2 intances minimum at a time. We want to put the instances behind a load balancer (start with ELB, after everything works, you may try ALB) We don't want unhealthy instances to get traffic We want to keep the state in s3 and manage Lock in DynamoDB

## EC2 Module - 

Use free-tier instances only (t2.micro)
All resources must be a part of the VPC you created earlier
All resources will use public subnets, to allow traffic from outside
The instances should allow incoming traffic on port 80 from the LB only
The instances should allow SSH access to the admin user
Incoming traffic for each resource must restrict the port-range to the minimum
Global-RDS


## More to do - 20.11 

1. run terraform init and upload all existing code - VPC and Load balancer
2. Finish the RDS and EC2 modules
3. Install Chef and make cookbooks
4. Run the application on prodaction and test if it work

##  Questions
1. load balancer - porotocol - HTTPS? (SSL policy and certificate arn)
2. load balancer - port - inseart as var?


## Suggestions for improvement (only with enough time):

1. Security Groups:
Create a file separately for security group and pull in each module the relevant group

2. 


