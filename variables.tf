variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}
variable "asg_min_size" {
  default = 1
}

variable "asg_max_size" {
  default = 3
}

variable "asg_desired_capacity" {
  default = 1
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" 
}

variable "allowed_ip" {
  description = "IP address allowed to access the frontend"
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_name" {
  type        = string
  description = "The SSH key name for EC2 instances"
  default     = "my-ssh-key"  # Provide a default key name, change as needed
}


variable "iam_role" {
  type        = string
  description = "IAM role for the instances"
  default     = "my-iam-role"  # Provide a default IAM role name, change as needed
}



variable "user_data" {
  type        = string
  description = "User data for instance configuration"
  default     = "#!/bin/bash\n# Default user data script\n"  # Default script, change as needed
}

