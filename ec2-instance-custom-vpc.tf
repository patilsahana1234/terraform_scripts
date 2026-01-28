resource "aws_instance" "custom_vpc_ec2" {
  provider = aws.canada

  ami           = "ami-0f8f81db908241ec9"
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.custom_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "EC2-Custom-VPC-Canada"
  }
}