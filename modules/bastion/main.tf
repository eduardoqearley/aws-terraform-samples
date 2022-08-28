data "aws_caller_identity" "self" {}

resource "aws_security_group" "bastion" {
  name        = "${var.environment}-bastion"
  description = "${var.environment}-bastion"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description = "ssh ${var.environment}-bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion-host" {
  ami           = "${var.ami}"
  instance_type = "t2.small"
  associate_public_ip_address = "true"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  key_name   = "${var.key_name}"
  disable_api_termination="true"

}
resource "aws_eip" "eip_bastion" {
  vpc = true
  tags = merge({ Name = "${local.key} bastion" }, local.common_tags)
}

resource "aws_eip_association" "eip_association_bastion" {
  instance_id   = aws_instance.bastion-host.id
  allocation_id = aws_eip.eip_bastion.id
}

output "bastion_ip" {
  description = "IP for the bastion server"
  value = aws_eip.eip_bastion.public_ip
  
  # tags = {
  #   Name = "${var.environment}-bastion"
  # }

}
locals {
  key          = "${data.aws_caller_identity.self.account_id}-${var.project}"
  
  common_tags = {
    Terraform = "true"
    Project   = var.project
  }
}
