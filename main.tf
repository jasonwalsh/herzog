terraform {
  required_version = "~> 0.11.11"
}

locals {
  # Options passed to `packer build` (e.g., `packer build [options] TEMPLATE`)
  options = {
    instance_type = "${var.instance_type}"
    region        = "${data.aws_region.current.name}"
    ssh_username  = "${var.ssh_username}"
  }
}

data "aws_ami" "ami" {
  filter {
    name   = "tag:id"
    values = ["${null_resource.packer.id}"]
  }

  most_recent = true
  owners      = ["self"]
}

data "aws_region" "current" {}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = "${aws_default_vpc.default_vpc.id}"
}

module "allow_ssh" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "2.11.0"

  ingress_cidr_blocks = [
    "0.0.0.0/0",
  ]

  name   = "allow_ssh"
  vpc_id = "${aws_default_vpc.default_vpc.id}"
}

resource "aws_default_vpc" "default_vpc" {}

resource "aws_key_pair" "key_pair" {
  public_key = "${file("${pathexpand(var.public_key)}")}"
}

resource "local_file" "options" {
  content  = "${jsonencode(merge(local.options, var.options))}"
  filename = "${path.module}/packer/variables.json"
}

resource "null_resource" "packer" {
  provisioner "local-exec" {
    command     = "packer build -var id=${self.id} -var-file variables.json ${var.template}"
    working_dir = "packer"
  }

  depends_on = ["local_file.options"]
}

module "instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "1.14.0"

  ami                         = "${data.aws_ami.ami.id}"
  associate_public_ip_address = true
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.key_pair.key_name}"
  name                        = "${null_resource.packer.id}"
  subnet_id                   = "${element(data.aws_subnet_ids.subnet_ids.ids, 0)}"

  vpc_security_group_ids = [
    "${module.allow_ssh.this_security_group_id}",
  ]
}
