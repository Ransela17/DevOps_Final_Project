# Clood School - Final Project
Purpose - build infrastructure for the Flask app.
In this project, infrastructure was built for migo application and the main technologies were used:
AWS
Terraform
Docker
Python

# Terraform Infrastructur

Create environment modules with all the necessary resources to enable end-to-end interaction with a Web-app include VPC, RDS, Load-Balancer and EC2 on AWS

Details:
- Creating S3 bucket and DynamoDb - for state files - manual
- VPC and Gateway resources
- Subnets
- Security groups
- RDS - PostgreSQL
- Load-Balancer
- Autoscaling Group
- LaunchConfiguration (and a user-data script included)

# Docker

1. Create a Docker file for migo app and manual upload to Amazon Elastic Container Registry (ECR) - a fully managed Docker container registry
2. Automatic Loading the container when launching the EC2 by LaunchConfiguration (and a user-data script included)
3. Automatic Connet the postgreSQL (DB) to the EC2 instance




