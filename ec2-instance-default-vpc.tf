resource "aws_instance" "default_vpc_ec2" {
  provider = aws.sydney

  ami           = "ami-048ab8ac7e8c6533d" # Replace with valid AMI
  instance_type = "t3.micro"

  tags = {
    Name = "default-vpc-ec2"
  }
}
