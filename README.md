# packer_amis
Currently generates a single AWS AMI based on the Amazon Linux 2 base image for the purpose of hosting a self-managed Wordpress image.

After cloning do the following in the root dir:

`packer init .`

`packer validate .`

`packer build aws-linux2.pkr.hcl`
