resource "aws_lb" "this" {
  name                      = var.lb_name
  internal                  = var.internal
  load_balancer_type        = var.lb_type
  security_groups           = var.security_group_ids
  subnets                   = var.subnet_ids
  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = var.fixed_response_message
    }
  }
}

resource "aws_lb_target_group" "this" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = var.tags
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 1
  min_size             = 1
  max_size             = 2
  vpc_zone_identifier  = var.subnet_ids
  launch_configuration = aws_launch_configuration.this.id

  target_group_arns = [aws_lb_target_group.this.arn]  


}

resource "aws_launch_configuration" "this" {
  name = "tushar"
  image_id = var.ami_id
  instance_type = var.instance_type
  security_groups = var.security_group_ids

  lifecycle {
    create_before_destroy = true
  }
}
