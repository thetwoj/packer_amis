# packer_amis
Currently generates a single AWS AMI based on the Amazon Linux 2 base image for the purpose of hosting a self-managed Wordpress image.

Requires [Packer](https://www.packer.io/) and [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) to be installed.

After cloning do the following in the root dir:

`packer init .`

`packer validate .`

`packer build aws-linux2.pkr.hcl`
