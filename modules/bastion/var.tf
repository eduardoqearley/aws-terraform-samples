variable "key_name" {
}
variable "subnet_id" {
}

variable "vpc_id" { 
}

variable "environment" {
}

variable "ami" { 
}

variable "availability_zone" {
}

variable "project" {
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  tags = {
    Name = "${var.environment}-bastion"
  }
}
