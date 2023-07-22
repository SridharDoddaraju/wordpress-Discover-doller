provider "aws" {
  region = "ap-south-1"  # Use ap-south-1 for the desired AWS region (Mumbai)
}

# VPC and Subnets
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"  # Replace with your desired availability zone in ap-south-1
}

resource "aws_security_group" "web_server_sg" {
  name_prefix = "web-server-sg-"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for SSH access (port 22) from your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace "your-public-ip" with your public IP address
  }
}

# EC2 Instance for WordPress
resource "aws_instance" "wordpress_vm" {
  ami                    = "ami-006935d9a6773e4ec"  # Amazon Linux 2 AMI ID for ap-south-1 region
  instance_type          = "t2.micro"               # Replace with your desired instance type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  # Use the "sridhar-key.pem" for SSH access
  key_name               = "sridhar-key"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              EOF

  tags = {
    Name = "WordPress VM"
  }
}

