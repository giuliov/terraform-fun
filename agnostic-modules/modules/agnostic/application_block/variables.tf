variable location {
  type = object({
    cloud     = string,
    geography = string,
    section   = string
  })
}

variable quality_of_service {
  type = object({
    performance     = number,
    security        = number,
    load            = number,
    confidentiality = number
  })
}

variable name {
  type = string
}

variable platform {
  type = string # vm, k8s, faas
}

variable vm_platform {
  type = object({
    os         = string,
    os_version = string
  })
  default = null
}

variable k8s_platform {
  type = object({
    os = string
  })
  default = null
}

variable tags {
  type = map(string)
}
