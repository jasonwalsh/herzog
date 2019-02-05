[![CircleCI](https://img.shields.io/circleci/project/github/jasonwalsh/herzog.svg?style=flat-square)](https://circleci.com/gh/jasonwalsh/herzog)

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
| vagrantfile | The Vagrantfile template |
