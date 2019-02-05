terraform {
  required_version = "~> 0.11.11"
}

locals {
  # Options passed to `packer build` (e.g., `packer build [options] TEMPLATE`)
  options = {
    instance_type    = "${var.instance_type}"
    region           = "${data.aws_region.current.name}"
    ssh_keypair_name = "${aws_key_pair.key_pair.key_name}"
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

data "template_file" "vagrantfile" {
  template = "${file("${path.module}/Vagrantfile.tpl")}"

  vars {
    aws_ami           = "${data.aws_ami.ami.id}"
    key_name          = "${aws_key_pair.key_pair.key_name}"
    private_key       = "${var.private_key}"
    security_group_id = "${aws_security_group.security_group.id}"
    ssh_username      = "${var.ssh_username}"
  }
}

resource "aws_security_group" "security_group" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
  }
}

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
