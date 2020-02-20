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

data aws_ami linux {
  most_recent = true
  name_regex  = var.vmimage_name_regex

  filter {
    name   = "name"
    values = [var.vmimage_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.vmimage_owner]
}

data aws_ami windows {
  most_recent = true
  name_regex  = var.vmimage_name_regex

  filter {
    name   = "name"
    values = [var.vmimage_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.vmimage_owner]
}


resource aws_instance vm {
  count = var.count_

  ami                         = var.vm_os_windows ? data.aws_ami.windows.id : (var.vm_os_linux ? data.aws_ami.linux.id : "ERROR: invalid OS")
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.app_subnet.id
  vpc_security_group_ids      = [] #TODO
  associate_public_ip_address = false

  tags = {
    Name = "${var.vm_name}-vm"
    Env  = lower(terraform.workspace)
  }
}
