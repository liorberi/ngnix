terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

#creating VPC 
resource "aws_vpc" "nginx-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"
}

#Create a public subnet for the VPC we created above

resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id                  = aws_vpc.nginx-vpc.id // Referencing the id of the VPC from abouve code block
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" // Makes this a public subnet
  availability_zone       = "us-west-2a"
}

# Create an Internet Gateway for the VPC. The VPC require an IGW to communicate over the internet.

resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.nginx-vpc.id
}

# Create a custom route table for the VPC.

resource "aws_route_table" "prod-public-crt" {
  vpc_id = aws_vpc.nginx-vpc.id
  route {
    cidr_block = "0.0.0.0/0"                      //associated subnet can reach everywhere
    gateway_id = aws_internet_gateway.prod-igw.id //CRT uses this IGW to reach internet
  }
tags = {
    Name = "prod-public-crt"
  }
}


#Associate the route table with the public subnet.

resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = aws_subnet.prod-subnet-public-1.id
  route_table_id = aws_route_table.prod-public-crt.id
}

#Create a security group to allow SSH access and HTTP access.

resource "aws_security_group" "ssh-allowed" {
vpc_id = aws_vpc.nginx-vpc.id
egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
cidr_blocks = ["0.0.0.0/0"] // Ideally best to use your machines' IP. However if it is dynamic you will need to change this in the vpc every so often.
  }
ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



#Add the following code block in the main.tf file to associate an SSH public key with the AWS EC2 instance.

resource "aws_key_pair" "aws-key" {
  key_name   = "aws-key"
  public_key = file(var.PUBLIC_KEY_PATH)// Path is in the variables file}
 }
  
resource "aws_instance" "nginx_server" {
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"
tags = {
    Name = "nginx_server"
  }
  
   }
  
resource "aws_instance" "nginx_server2" {
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"
tags = {
    Name = "nginx_server2"
  }
# VPC
  subnet_id = aws_subnet.prod-subnet-public-1.id
# Security Group
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
#  the Public SSH key
  key_name = aws_key_pair.aws-key.id
# nginx installation
  # storing the nginx.sh file in the EC2 instnace
  provisioner "file" {
    source      = "nginx.sh"
    destination = "/tmp/nginx.sh"
  }
  # Exicuting the nginx.sh file
  # Terraform does not reccomend this method becuase Terraform state file cannot track what the scrip is provissioning
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
    ]
  }
# Setting up the ssh connection to install the nginx server
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${var.PRIVATE_KEY_PATH}")
  }
}




###############################

# Load balancer listener variables
## HTTP
variable "create_lb_http_listener" {
  description = "If true add a HTTP listener"
  default     = false
}

## Load balancer HTTP listener port
variable "lb_http_listener_port" {
  description = "HTTP listener port of the loadbalancer"
  default     = 80
}

## load balancer http redirect listener
variable "create_lb_http_redirect_listener" {
  default = false
}

## Load balancer HTTP redirect listener port
variable "lb_http_redirect_listener_port" {
  description = "HTTP redirect listener port of the loadbalancer"
  default     = 80
}

## Load balancer HTTP redirect to protocol
variable "lb_http_redirect_to_protocol" {
  description = "HTTP redirect listener to loadbalancer protocol"
  default     = "HTTPS"
}

## Load balancer HTTP redirect to port
variable "lb_http_redirect_to_port" {
  description = "HTTP redirect listener to loadbalancer port"
  default     = 443
}

## HTTPS
variable "create_lb_https_listener" {
  description = "If true add a HTTPS listener"
  default     = false
}

## Load balancer HTTPS offloading?
variable "enable_lb_https_offloading" {
  description = "If true offload to HTTP"
  default     = true
}

## Loadbalancer HTTPS listener port
variable "lb_https_listener_port" {
  description = "HTTPS listener port of the loadbalancer"
  default     = 443
}

## Certificate ARN for the HTTPS listener
variable "certificate_arn" {
  description = "Certificate ARN for the HTTPS listener"
  default     = null
}

