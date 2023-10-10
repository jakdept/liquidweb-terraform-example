resource "liquidweb_network_load_balancer" "loadbalancer" {
  depends_on = [data.liquidweb_network_zone.testing_zone]
  name       = "lb.0.terraform-testing.api.hostbaitor.com"

  region = data.liquidweb_network_zone.testing_zone.region_id

  nodes = liquidweb_cloud_server.webserver[*].ip

  service {
    src_port  = 80
    dest_port = 80
  }

  service {
    src_port  = 443
    dest_port = 443
  }

  #session_persistence = false
  #ssl_termination = false
  strategy = "roundrobin"
}

output "lb_vip" {
  value = liquidweb_network_load_balancer.loadbalancer.vip
}