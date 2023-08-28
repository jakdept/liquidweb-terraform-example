resource "liquidweb_network_load_balancer" "testing_lb" {
  depends_on = ["data.liquidweb_network_zone.testing_zone"]
  name       = "lb.0.terraform-testing.api.jackdept.dev"

  region = data.liquidweb_network_zone.testing_zone.region_id

  nodes = liquidweb_storm_server.testing_servers[*].ip

  service {
    src_port  = 80
    dest_port = 80
  }

  service {
    src_port  = 1337
    dest_port = 1337
  }

  #session_persistence = false
  #ssl_termination = false
  strategy = "roundrobin"
}

resource "liquidweb_storage_block_volume" "testing_block_volume" {
  domain = "block_volume.terraform-testing.api.jakdept.dev"
  size   = 10
}

resource "liquidweb_network_dns_record" "testing_a_record" {
  name  = "dns.terraform-testing.api.domain.jakdept.dev"
  type  = "A"
  rdata = "127.0.0.1"
  zone  = "dns.terraform-testing.api.jakdept.dev"
}

output "block_storage" {
  value = liquidweb_storage_block_volume.testing_block_volume.domain
}

output "domain_a_name" {
  value = liquidweb_network_dns_record.testing_a_record.name
}


output "lb_vip" {
  value = liquidweb_network_load_balancer.testing_lb.vip
}
