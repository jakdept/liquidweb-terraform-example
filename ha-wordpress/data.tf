terraform {
  required_providers {
    liquidweb = {
      source  = "liquidweb/liquidweb"
      version = ">= 1.7.0"
    }
  }
}

resource "random_id" "server" {
  byte_length = 1
  # count       = 1
}

resource "random_password" "server" {
  length  = 20
  special = false
}

resource "random_password" "wordpress_dbpass" {
  length  = 20
  special = true
}

resource "random_password" "wordpress_salt" {
  length = 32
  special = true
}

data "liquidweb_network_zone" "zonec" {
  name        = "Zone C"
  region_name = "US Central"
}

# data "template_file" "tiup_config" {
#   template = file("${path.module}/templates/tiup.yaml.tmpl")
#   vars = {
#     servers = liquidweb_cloud_server.db_server
#   }
# }

resource "liquidweb_network_dns_record" "db_server" {
  count = 3

  name  = liquidweb_cloud_server.db_server[count.index].domain
  type  = "A"
  rdata = liquidweb_cloud_server.db_server[count.index].ip
  zone  = var.top_domain
}

output "server_hostname" {
  value = liquidweb_network_dns_record.db_server[*].name
}