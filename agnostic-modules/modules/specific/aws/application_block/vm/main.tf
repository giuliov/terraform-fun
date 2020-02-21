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
  count = var.count_

  most_recent = true
  name_regex  = var.vm_os_image_spec.name_regex

  filter {
    name   = "name"
    values = [var.vm_os_image_spec.name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.vm_os_image_spec.owner]
}

data aws_ami windows {
  count = var.count_

  most_recent = true
  name_regex  = var.vm_os_image_spec.name_regex

  filter {
    name   = "name"
    values = [var.vm_os_image_spec.name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.vm_os_image_spec.owner]
}


resource aws_instance vm {
  count = var.count_

  ami                         = var.vm_os_windows ? data.aws_ami.windows[0].id : (var.vm_os_linux ? data.aws_ami.linux[0].id : "ERROR: invalid OS")
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.app_subnet.id
  vpc_security_group_ids      = [] #TODO
  associate_public_ip_address = false

  tags = {
    Name = "${var.vm_name}-vm"
    Env  = lower(terraform.workspace)
  }
}
