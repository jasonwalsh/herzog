[![CircleCI](https://img.shields.io/circleci/project/github/jasonwalsh/herzog.svg?style=flat-square)](https://circleci.com/gh/jasonwalsh/herzog)

## Contents

- [Motivation](#motivation)
- [Requirements](#requirements)
- [Usage](#usage)
  - [Environment Variables](#environment-variables)

## Motivation

The purpose of this repository is to demonstrate a fully automated image deployment and testing pipeline.

## Requirements

- [Packer](https://packer.io/downloads.html)
- [Terraform](https://www.terraform.io/downloads.html)
- [Vagrant](https://www.vagrantup.com/downloads.html)

## Usage

This repository builds Amazon Machine Images (AMIs) using software called [Packer](https://packer.io/). After Packer finishes the build, it uploads an artifact (AMI) to the AWS account associated with the AWS Access Key ID and AWS Secret Access Key provided by the user. The AMI is then available for use by Vagrant.

The [main.tf](main.tf) file wraps the Packer [build](https://packer.io/docs/commands/build.html) command in a Terraform configuration file and creates the security group used via the Vagrant AWS provider to allow incoming SSH connections.

    $ terraform init
    $ terraform apply

### Environment Variables

The following environment variables are required to use this repository.

| Name                    | Required           |
|-------------------------|:------------------:|
| `AWS_ACCESS_KEY_ID`     | :heavy_check_mark: |
| `AWS_DEFAULT_REGION`    | :heavy_check_mark: |
| `AWS_SECRET_ACCESS_KEY` | :heavy_check_mark: |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| instance\_type | The EC2 instance type to use while building the AMI | string | `"t2.small"` | no |
| options | https://packer.io/docs/commands/build.html#options | map | `<map>` | no |
| private\_key | The private key material | string | `"~/.ssh/id_rsa"` | no |
| public\_key | The public key material | string | `"~/.ssh/id_rsa.pub"` | no |
| ssh\_username | The username to connect to SSH with | string | n/a | yes |
| template | The Packer template | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vagrant | SSH into a running Vagrant machine |
