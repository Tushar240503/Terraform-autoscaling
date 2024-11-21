variable "lb_name" {
  description = "The name of the load balancer"
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal or internet-facing"
  type        = bool
}

variable "lb_type" {
  description = "The type of load balancer (application or network)"
  type        = string
}

variable "security_group_ids" {
  description = "The security groups to associate with the load balancer"
  type        = list(string)
}

variable "subnet_ids" {
  description = "The subnets to associate with the load balancer"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
}

variable "listener_port" {
  description = "The port the listener will listen on"
  type        = number
}

variable "listener_protocol" {
  description = "The protocol for the listener"
  type        = string
}

variable "fixed_response_message" {
  description = "The fixed response message for testing"
  type        = string
}

variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "The port for the target group"
  type        = number
}

variable "target_group_protocol" {
  description = "The protocol for the target group"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the target group will be created"
  type        = string
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

