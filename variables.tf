variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_cidr_block" {
  type    = string
  default = "10.0.2.0/24"
}

variable "ami" {
  type    = string
  default = "ami-0c94855ba95c71c99"
}
