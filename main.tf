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

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}


resource "aws_vpc" "nginx-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"
}

resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id                  = aws_vpc.nginx-vpc.id // Referencing the id of the VPC from abouve code block
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" // Makes this a public subnet
  availability_zone       = "us-west-2a"
}

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



