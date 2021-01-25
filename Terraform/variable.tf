variable "bucket" {
  type = string
  description = "Terraform state bucket"
  default = "ec2_terraform"
}

variable "path" {
  type = string
  description = "Terraform state path"
  default = "prod"
}

variable "instance_name" {
  type = string
  description = "Instance aws ec2"
  default = "instance_serverless_conte"
}

variable "security_group" {
  type        = string
  description = "Instance name"
  default     = "security_group_serverless_conte"
}

variable "region" {
  type = string
  description = "AWS region"
  default = "eu-west-3"
}

variable "instance_type" {
  type = string
  description = "Instance type"
  default = "t2.micro"
}

variable "instance_number" {
  type = number
  description = "Instance number"
  default = 1
}

variable "create_instance" {
  type = bool
  description = "Create instance or not"
  default = true
}

variable "sshKey" {
  type = string
  default = "tp_dev_ynov"
}
variable "ssh_port" {
  type        = number
  description = "SSH Port"
  default     = 22
}

variable "http_port" {
  type        = number
  description = "HTTP Port"
  default     = 80
}
