variable "my_global" {
  default = "someGlobal"
}

data "external" "example" {
  program = ["powershell", "${path.module}/uploader.ps1 -yourArg ${var.my_global}"]
}

output "the_result" {
  value = "${data.external.example.result}"
}
