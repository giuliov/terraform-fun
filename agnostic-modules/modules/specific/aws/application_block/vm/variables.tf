variable count_ {
  type    = number
  default = 0
}

variable main_region {
  type = string
}

variable subnet_name {
  type = string
}

variable vm_name {
  type = string
}

variable vm_os_windows {
  type = bool
}

variable vm_os_linux {
  type = bool
}

variable vm_os_image_spec {
  type = object({
    name_regex  = string
    name_filter = string
    owner       = string
  })
}

