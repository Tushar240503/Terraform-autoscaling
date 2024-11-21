variable "launch_template_name" {
  description = "The name of the launch template"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to launch the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "The SSH key pair for EC2 instances"
  type        = string
}

variable "security_group_ids" {
  type = list(string)
}


variable "iam_role" {
  description = "IAM role for EC2 instances"
  type        = string
}

variable "user_data" {
  description = "The user data script to run on instance start"
  type        = string
}

variable "desired_capacity" {
  description = "The desired capacity of the Auto Scaling Group"
  type        = number
}

variable "min_size" {
  description = "The minimum size of the Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling Group"
  type        = number
}

variable "subnet_ids" {
  description = "The subnets where the ASG will launch instances"
  type        = list(string)
}
variable "target_group_arns" {
  description = "List of target group ARNs for the auto scaling group"
  type        = list(string)
  default     = []
}

