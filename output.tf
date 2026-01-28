output "sydney_ec2_id" {
  value = aws_instance.default_vpc_ec2.id
}

output "canada_ec2_id" {
  value = aws_instance.custom_vpc_ec2.id
}