output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.asg_launch_template.id
}

output "autoscaling_group_id" {
  description = "ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.id  # Use 'asg' instead of 'this'
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name  # Use 'asg' instead of 'this'
}

# output "instance_ids" {
#   value = data.aws_autoscaling_group.asg_data.instances[*].id  # Access instance IDs from the data block
# }