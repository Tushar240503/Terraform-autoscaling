output "public_ip" {
  value = aws_instance.app_instance.public_ip
}

output "id" {
  value = aws_instance.app_instance.id
}
