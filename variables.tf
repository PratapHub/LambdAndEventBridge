variable "ami" {

type = string
description = "Providing AMI"
}

variable "instance_type" {
type = string
description = "providing instance type"
}

variable "subnet_id"{
type = string
description = "provide requried subnet in which ec2 requried"
}

variable "vpc_security_group_ids" {
type = string
description = "Provide requried security group id"
}

variable "env" {
type = string
description = "Provide env details"
}

variable "key_name" {
type = string
description = "provide key pair"
}

variable "access_key" {
type = string
description = "Please provide access_key"
}

variable "secret_key" {
type = string
description = "Please provide secret_key"
}

variable "region" {
type = string
description = "Please provide"
}