#variables.tf file

variable "PRIVATE_KEY_PATH" {
  default = "aws-key"
}
variable "PUBLIC_KEY_PATH" {
  default = "/home/ubuntu/terraform/terrafom.pub"
}
variable "EC2_USER" {
  default = "ubuntu"
}
