packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "amazon-ebs" "linux2" {
  ami_name      = "packer-wordpress-{{timestamp}}"
  instance_type = "t4g.micro"
  region        = "us-east-2"
  profile       = "personal"
  tags = {
    App = "Wordpress"
    Name = "Packer Wordpress"
  }

  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    delete_on_termination = true
    encrypted             = true
    volume_size           = 8
    volume_type           = "gp2"
  }

  source_ami_filter {
    filters = {
      architecture        = "arm64"
      name                = "*amzn2-ami-hvm-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  ssh_username = "ec2-user"
}

build {
  name = "packer-wordpress"
  sources = ["source.amazon-ebs.linux2"]

  provisioner "shell" {
    inline = [
      "echo Updating yum",
      "sudo yum update -y",
      "echo Installing htop, vim, amazon-efs-utils, statsd",
      "sudo yum install -y htop vim amazon-efs-utils statsd",
    ]
  }

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
    user          = "ec2-user"
    use_proxy     = false
  }

  provisioner "shell" {
    inline = [
      "echo Updating yum one last time",
      "sudo yum update -y",
    ]
  }
}
