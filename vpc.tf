resource "aws_vpc" "custom_vpc" {
  provider = aws.canada

  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "Custom-VPC-Canada"
  }
}
resource "aws_subnet" "custom_subnet" {
  provider = aws.canada

  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "ca-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-Canada"
  }
}
resource "aws_internet_gateway" "igw" {
  provider = aws.canada

  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "IGW-Canada"
  }
}
resource "aws_route_table" "public_rt" {
  provider = aws.canada

  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT-Canada"
  }
}

resource "aws_route_table_association" "rt_assoc" {
  provider = aws.canada

  subnet_id      = aws_subnet.custom_subnet.id
  route_table_id = aws_route_table.public_rt.id
}