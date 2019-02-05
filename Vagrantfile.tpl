Vagrant.require_version ">= 2.2.0"

Vagrant.configure("2") do |config|
  config.vagrant.plugins = "vagrant-aws"

  config.vm.box = "dummy"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  config.vm.provider "aws" do |aws, override|
    aws.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    aws.ami = "${aws_ami}"
    aws.instance_type = "${instance_type}"
    aws.keypair_name = "${key_name}"
    aws.region = ENV["AWS_DEFAULT_REGION"]
    aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    aws.security_groups = [
      "${security_group_id}"
    ]
    override.ssh.private_key_path = File.expand_path("${private_key}")
    override.ssh.username = "${ssh_username}"
  end

  config.vm.synced_folder ".", "/vagrant", type: "rsync"
end
