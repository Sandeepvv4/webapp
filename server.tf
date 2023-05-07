provider "aws" {
  region = var.aws_region
}
resource "aws_security_group" "server_sg" {
  name_prefix = "ec2-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "my-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type 
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.server_sg.id]

  tags = {
    Name = var.instance_name
  }
}
