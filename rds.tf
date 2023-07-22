provider "aws" {
  region = "us-east-1"
}

# Create a VPC and subnets
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"


resource "aws_security_group" "rds" {
  vpc_id = aws_vpc.main.id


  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "wordpress_db" {
  identifier             = "wordpress-db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  username               = "root"
  password               = "root@a23"
  multi_az               = false
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds.id]
  subnet_group_name      = "wordpress-db-subnet-group"


  subnet_ids = [aws_subnet.private.id]

}


output "rds_endpoint" {
  value = aws_db_instance.wordpress_db.endpoint
}
