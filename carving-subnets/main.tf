variable "vnet_range" {
  default = "10.40.0.0/16"
}

variable "env_base_index" {
  default = "0" # 0 = first
}

resource "null_resource" "subnets" {
    triggers = {
        fe_cidr = "${ cidrsubnet(var.vnet_range, 8, 3*var.env_base_index + 1) }"
        be_cidr = "${ cidrsubnet(var.vnet_range, 8, 3*var.env_base_index + 2) }"
        db_cidr = "${ cidrsubnet(var.vnet_range, 8, 3*var.env_base_index + 3) }"
    }
}

resource "null_resource" "fe_subnet_hosts" {
    #depends_on = ["null_resource.subnets"]
    triggers = {
        host1 = "${ cidrhost(null_resource.subnets.triggers.fe_cidr, 1) }"
        host2 = "${ cidrhost(null_resource.subnets.triggers.fe_cidr, 2) }"
    }
}

resource "null_resource" "be_subnet_hosts" {
    #depends_on = ["null_resource.subnets"]
    triggers = {
        host1 = "${ cidrhost(null_resource.subnets.triggers.be_cidr, 1) }"
        host2 = "${ cidrhost(null_resource.subnets.triggers.be_cidr, 2) }"
        host3 = "${ cidrhost(null_resource.subnets.triggers.be_cidr, 3) }"
    }
}

resource "null_resource" "db_subnet_hosts" {
    #depends_on = ["null_resource.subnets"]
    triggers = {
        host1 = "${ cidrhost(null_resource.subnets.triggers.db_cidr, 42) }"
    }
}

output "oooogggg" {
  value = <<EOF
Subnets in network ${var.vnet_range} are:
 F/E ${null_resource.subnets.triggers.fe_cidr}
 B/E ${null_resource.subnets.triggers.be_cidr}
 DB ${null_resource.subnets.triggers.db_cidr}
An host in F/E is ${null_resource.fe_subnet_hosts.triggers.host1}
An host in B/E is ${null_resource.be_subnet_hosts.triggers.host3}
one in DB is ${null_resource.db_subnet_hosts.triggers.host1}
EOF
}
