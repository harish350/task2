provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}
resource "aws_vpc" "dev" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "dev-pub-1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = var.vpc_cidr1
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
}

resource "aws_instance" "ec2_instance" {
  ami           = var.amis
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.id
  vpc_id        = aws_vpc.id

  tags = {
    Name = "App_Instance"
  }

  

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${var.key_name}.pem")
      host        = self.public_ip
    }
  

  
}

output "InstanceId" {
  value = aws_instance.ec2_instance.id
}

output "PublicIpAddress" {
  value = aws_instance.ec2_instance.public_ip
}
