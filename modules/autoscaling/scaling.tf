resource "aws_launch_template" "asg_launch_template" {
  name                = var.launch_template_name
  image_id            = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  iam_instance_profile {
    name = var.iam_role
  }
  user_data = base64encode(var.user_data)

  network_interfaces {
    security_groups = var.security_group_ids  # Use security_groups inside network_interfaces block
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = var.subnet_ids
  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }

  health_check_type            = "EC2"
  health_check_grace_period    = 300
  wait_for_capacity_timeout     = "0"
  force_delete                 = true
  target_group_arns            = var.target_group_arns  # Add target group ARNs here

  lifecycle {
    create_before_destroy = true
  }
}


data "aws_autoscaling_group" "asg_data" {
  name = aws_autoscaling_group.asg.name
}
