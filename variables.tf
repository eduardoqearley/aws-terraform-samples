variable "public_key" {
  description = "Your public key to connect to the instances"
  type        = string
}

variable "acme_domain_name" {
  description = "The domain name you'd like to use for the Let's Encrypt certificate issuance"
  type        = string
}

variable "acme_cert_issuer" {
  description = "The cert issuer to use for the Let's Encrypt certificate issuance"
  type        = string
  default     = "letsencrypt-staging"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "eks-prod"
}
variable "availability_zones" {
  description = "The availability zones to use"
  type        = list
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "main_cidr" {
  description = "The main CIDR block to use"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "The private subnets to use"
  type        = list
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "The public subnets to use"
  type        = list
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "eks_cluster_version" {
  description = "The version of K8S to use on EKS"
  type        = string
  default     = "1.15"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "bastion_ami" {
  default = "ami-08be3c327cd286962"  
}
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::051187635610:user/edward.earley"
      username = "edward.earley"
      groups   = ["system:masters"]
    },
  ]
}
