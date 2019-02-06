variable "options" {
  default     = {}
  description = "https://packer.io/docs/commands/build.html#options"
  type        = "map"
}

variable "instance_type" {
  default     = "t2.small"
  description = "The EC2 instance type to use while building the AMI"
}

variable "public_key" {
  default     = "~/.ssh/id_rsa.pub"
  description = "The public key material"
}

variable "ssh_username" {
  description = "The username to connect to SSH with"
}

variable "template" {
  description = "The Packer template"
}
