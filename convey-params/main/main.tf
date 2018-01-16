data "template_file" "configurationArguments" {
  template = <<SETTINGS
            "IISWebSite"  : "Default Web Site",
            "FQDNs"       : "vm_demo.example.com,demo.example.com"
SETTINGS

  vars {
    inject = "42"
  }
}

module "do_it_all" {
  source                 = "../module"
  configurationArguments = "${data.template_file.configurationArguments.rendered}"
}
