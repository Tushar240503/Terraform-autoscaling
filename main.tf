provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "three-tier-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "ap-south-1b"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"  # Replace `vpc = true` with `domain = "vpc"`
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "NatGateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route_table.id
}

module "database_instance" {
  source            = "./modules/instances"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.private.id
  security_group_ids = [aws_security_group.database.id]
  instance_name     = "database-server"
}

module "asg_backend" {
  source               = "./modules/autoscaling"
  launch_template_name = "Backend"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  security_group_ids   = [aws_security_group.backend.id]
  key_name             = var.key_name  
  iam_role             = var.iam_role
  desired_capacity     = 2
  min_size             = 1
  max_size             = 5
  subnet_ids           = [aws_subnet.private.id]
  user_data            = base64encode(var.user_data)
}

module "asg_frontend" {
  source               = "./modules/autoscaling"
  launch_template_name = "frontend"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  security_group_ids   = [aws_security_group.frontend.id]
  key_name             = var.key_name  
  iam_role             = var.iam_role
  desired_capacity     = 2
  min_size             = 1
  max_size             = 5
  subnet_ids           = [aws_subnet.public.id]
  user_data            = base64encode(var.user_data)
  target_group_arns    = [module.load_balancer.target_group_arn] 
}

module "load_balancer" {
  source                    = "./modules/LoadBalancer"
  lb_name                   = "my-load-balancer"  
  internal                  = false                
  lb_type                   = "application" 
  security_group_ids        = [aws_security_group.loadbalancer.id]      
  subnet_ids                = [aws_subnet.public.id] 
  enable_deletion_protection = true              
  tags                      = { Name = "MyLB" }   
  listener_port             = 80                     
  listener_protocol         = "HTTP"                
  fixed_response_message    = "OK"                   
  target_group_name         = "my-target-group"      
  target_group_port         = 80                     
  target_group_protocol     = "HTTP"                 
  vpc_id                    = aws_vpc.main.id       
}

