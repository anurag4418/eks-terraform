variable "aws_region" {
    default = "us-east-1"
}

variable "cluster-name" {
  default = "my-eks-cluster"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "pub_subnet_cidr" {
    type = list
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "ami_id" {
    default = "ami-02354e95b39ca8dec"
}

variable "instance_type" {
    default = "t2.micro"
}