variable "aws_region" {
  default = "ap-southeast-2"
}

variable "ami_id" {
  default = "ami-0f6ad051716c81af1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "ec2-key-pair"
}

variable "instance_name" {
  default = "my-ec2-instance"
}
