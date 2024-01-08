output "public_dns" {
  value = aws_instance.ec2instance.public_dns
}

output "public_ip" {
  value = aws_instance.ec2instance.public_ip
}

