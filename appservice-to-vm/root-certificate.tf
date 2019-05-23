resource "tls_private_key" "appsvcint_demo" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "appsvcint_demo" {
  key_algorithm   = "${tls_private_key.appsvcint_demo.algorithm}"
  private_key_pem = "${tls_private_key.appsvcint_demo.private_key_pem}"

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  dns_names = [
    "*.appsvcint_demo.com",
    "*.dev.appsvcint_demo.com",
  ]

  validity_period_hours = 168 # 168=1w, 720=1mo, 8766=1yr

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

data "external" "appsvcint_demo_pfx" {
  program = ["Powershell", "${path.module}/ConvertTo-PFX.ps1"]

  query = {
    certificate_pem = "${tls_self_signed_cert.appsvcint_demo.cert_pem}"
    private_key_pem = "${tls_private_key.appsvcint_demo.private_key_pem}"
    password        = "${var.cert_password}"
  }

  /* OUTPUT IS
  result = {
        cert_thumbprint,
        pfx_base64,
        cert_base64
  }
  */
}

# optional but important: save the locally generated certificate to Azure
resource "azurerm_key_vault_certificate" "appsvcint_demo" {
  count        = 0
  name         = "appsvcint-demo-cert"
  key_vault_id = "${data.azurerm_key_vault.giuliov_pro_demo.id}"

  certificate {
    contents = "${lookup(data.external.appsvcint_demo_pfx.result,"pfx_base64")}" # see https://github.com/terraform-providers/terraform-provider-external/issues/4
    password = "${var.cert_password}"
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = "${tls_private_key.appsvcint_demo.rsa_bits}"
      key_type   = "${tls_private_key.appsvcint_demo.algorithm}"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}

####### DEBUG

resource "null_resource" "appsvcint_demo_pfx" {
  triggers {
    dummy = "${lookup(data.external.appsvcint_demo_pfx.result,"cert_thumbprint")}"
  }

  provisioner "local-exec" {
    command = "echo Hi"
  }
}

/*
output "tls_self_signed_private_key_pem" {
  value = "${tls_private_key.appsvcint_demo.private_key_pem}"
}

output "tls_self_signed_cert_pem" {
  value = "${tls_self_signed_cert.appsvcint_demo.cert_pem}"
}

output "tls_self_signed_cert_thumbprint" {
  value = "${data.external.appsvcint_demo_pfx.result.cert_thumbprint}"
}
*/

