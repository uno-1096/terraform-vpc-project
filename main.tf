terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC 1 - terraform-course
resource "aws_vpc" "terraform_course" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-course"
  }
}

# VPC 2 - development-vpc
resource "aws_vpc" "development" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "development-vpc"
  }
}
# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.development.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "homelab-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.development.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "homelab-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.development.id
  tags = {
    Name = "homelab-igw"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.development.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "homelab-public-rt"
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}# Upload your SSH key to AWS
resource "aws_key_pair" "homelab" {
  key_name   = "homelab-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvV3oFOkTqFQKYBrQTbevfZ4GirpPtjioNmcX88decen/MKPVuqprBzIKHgXjebbPoRqDuhO/VtNLTjQEbJtlAXZi6qELwGcm3Z0mU3IBoRUxV9BGTh0BSs9sOi+9nmdZtuDmGR2csIazwtkfezKlN80Dbng4LISqhNt1MlU96xVc0lzhV7o1tQrX65Xc9qfR2f4JnfHApTMT3gNttFVh8EbbaaqmoSWrynWkKb609YkoqnhOIgFOFn+e8YRF6QLlU7HBTcjopVuyWQ+UDBEIMK3KEhoCx9dPu88HWiI40AUnaOZLkc6wmZreJCj7BXhpRxRtmwrtgc2eqhcdUIKFw0/piG2ODc5TdwCYMUnIwTqLoyVed5m35lAeeZV2kZczIDQBMohmvuOls1DgfdFiuEnsI9VkpC6J1rNtqdb4pbQd0lHwQaLCmTO8+dA0UMYmBti5AaiDoLblZ6SQY3mwMTgww5gKl9mlzUK7ju5cdUOwcz31xZX1KFpZfbCEve/ufHYh2E121QeFGB5BoP6P7HimIdm7Yo0egMNlB3Xb1ZbEuoh8VKh0pFV6OXjPAvRzJ1OqzJ35yxi39QS3tXJ52pUaMDm6sYBYsvUkvzkU863Tnpp4FsjQPHkaXz8q6zLc0yigaG7/nqYchNqHSk47i7psqDdhiPbKRKallnS6iUw=="
}

# Security Group - controls traffic in/out of your server
resource "aws_security_group" "homelab" {
  name        = "homelab-sg"
  description = "Homelab security group"
  vpc_id      = aws_vpc.development.id

  # Allow SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "homelab-sg"
  }
}

# EC2 Instance - your actual server
resource "aws_instance" "homelab" {
  ami                         = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 us-east-1
  instance_type               = "t3.micro"               # Free tier!
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.homelab.id]
  key_name                    = aws_key_pair.homelab.key_name
  associate_public_ip_address = true

  tags = {
    Name = "homelab-server"
  }
}# Elastic IP - locks your server's public IP permanently
resource "aws_eip" "homelab" {
  instance = aws_instance.homelab.id
  domain   = "vpc"
  tags = {
    Name = "homelab-eip"
  }
}
