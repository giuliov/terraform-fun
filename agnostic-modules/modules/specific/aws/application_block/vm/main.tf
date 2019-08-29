terraform {
  required_version = "~> 0.12"
}

provider "aws" {
  version = "~> 2.25"
  region  = var.main_region
}

data aws_subnet app_subnet {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}

data aws_ami ubuntu {
  most_recent = true
  name_regex  = "^.*ubuntu.*"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data aws_ami windows {
  most_recent = true
  name_regex  = "^.*Windows.*"

  filter {
    name   = "name"
    values = ["*Windows_Server-2019-English-Core-Base*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["801119661308"] # Amazon
}


resource aws_instance vm {
  count = var.count_

  ami                         = var.vm_os_windows ? data.aws_ami.windows.id : (var.vm_os_linux ? data.aws_ami.ubuntu.id : "ERROR: invalid OS")
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.app_subnet.id
  vpc_security_group_ids      = [] #TODO
  associate_public_ip_address = false

  tags = {
    Name = "${var.vm_name}-vm"
    Env  = lower(terraform.workspace)
  }
}
