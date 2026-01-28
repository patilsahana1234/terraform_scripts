provider "aws" {
  region = "eu-west-3"
}

# Fetch subnets from the VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Security Group
resource "aws_security_group" "web_sg" {
  name   = "static-web-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash

              # Disable OS firewall (CRITICAL)
              systemctl stop firewalld
              systemctl disable firewalld

              # Update and install packages
              yum update -y
              yum install -y httpd unzip wget

              # Start Apache
              systemctl start httpd
              systemctl enable httpd

              # Wait to ensure Apache is up
              sleep 10

              # Deploy website
              cd /tmp
              wget https://freewebsitetemplates.com/download/zootemplate.zip
              unzip zootemplate.zip
              cp -r zootemplate/* /var/www/html/

              chown -R apache:apache /var/www/html
              chmod -R 755 /var/www/html

              systemctl restart httpd
              EOF

  tags = {
    Name = "terraform-static-website"
  }
}
