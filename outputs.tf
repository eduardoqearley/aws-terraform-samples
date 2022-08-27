output "instance_ami" {
  value = module.sample.aws_instance.ubuntu.ami
}

output "instance_arn" {
  value = module.sample.aws_instance.ubuntu.arn
}
