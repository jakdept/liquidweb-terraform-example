variable "liquidweb_config_path" {
  type = string
}

terraform {
  required_providers {
    liquidweb = {
      source = "local.providers/liquidweb/liquidweb"
      version = "~> 1.5.8"
    }
  }
}

provider "liquidweb" {
  config_path = var.liquidweb_config_path
}

data "liquidweb_network_zone" "testing_zone" {
  name        = "Zone B"
  region_name = "US Central"
}

resource "liquidweb_storm_server" "testing_servers" {
  count = 2

  #config_id = "${data.liquidweb_storm_server_config.api.id}"
  config_id = 1090
  zone      = 12
  #data.liquidweb_network_zone.api.id
  template       = "UBUNTU_1804_UNMANAGED" // ubuntu 18.04
  domain         = "servers.0.${count.index}.terraform-testing.api.jakdept.dev"
  password       = "11111aA"
  public_ssh_key = file("${path.root}/devkey.pub")
}

output "region_id" {
  value = data.liquidweb_network_zone.testing_zone.region_id
}

output "instances" {
  value = liquidweb_storm_server.testing_servers.*.ip
}
