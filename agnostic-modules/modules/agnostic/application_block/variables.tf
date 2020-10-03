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
    security        = number, # not used
    load            = number, # not used
    confidentiality = number  # not used
  })
  validation {
    condition = can(
      contains(range(1, 5), var.quality_of_service.performance)
      && contains(range(1, 5), var.quality_of_service.security)
      && contains(range(1, 5), var.quality_of_service.load)
      && contains(range(1, 5), var.quality_of_service.confidentiality)
    )
    error_message = "Value must be between 1 (highest) and 5 (lowest)."
  }
}

variable name {
  type = string
}

variable platform {
  type = string # vm, k8s, faas
  validation {
    condition     = can(contains(["vm", "k8s"], var.platform))
    error_message = "Only \"vm\" and \"k8s\" are supported."
  }
}

variable vm_platform {
  type = object({
    os         = string,
    os_version = string
  })
  default = null
  validation {
    condition     = can(var.vm_platform != null && contains(["windows", "linux"], var.vm_platform.os))
    error_message = ".os property must be \"windows\" or \"linux\"."
  }
}

# not used
variable k8s_platform {
  type = object({
    os = string
  })
  default = null
}

variable tags {
  type = map(string)
}
