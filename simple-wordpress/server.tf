resource "liquidweb_cloud_server" "simple_server" {
  # count = 1

  #config_id = "${data.liquidweb_storm_server_config.api.id}"
  config_id = 1757
  zone      = data.liquidweb_network_zone.zonec.network_zone_id
  #data.liquidweb_network_zone.api.id
  template       = "ROCKYLINUX_8_UNMANAGED"
  domain         = "wordpress-host${random_id.server.dec}.us-midwest-2.${var.top_domain}"
  public_ssh_key = file("${path.root}/default.pub")
  password       = random_password.server.result

  provisioner "file" {
    source      = "templates/site.conf"
    destination = "/etc/nginx/conf.d/site.conf"
  }
  provisioner "file" {
    source      = template_file.wp-config.rendered
    destination = "/var/www/html/site/wp-config.php"
  }
  provisioner "remote-exec" {

  }
}

resource "liquidweb_network_dns_record" "server_dns" {
  name  = liquidweb_cloud_server.simple_server.domain
  type  = "A"
  rdata = liquidweb_cloud_server.simple_server.ip
  zone  = var.top_domain
}

resource "liquidweb_network_dns_record" "wordpress_record" {
  name  = var.site_name
  type  = "A"
  rdata = liquidweb_cloud_server.simple_server.ip
  zone  = var.top_domain
}

output "server_hostname" {
  value = liquidweb_network_dns_record.server_dns.name
}

output "domain_a_name" {
  value = liquidweb_network_dns_record.wordpress_record.name
}

output "instances" {
  value = liquidweb_cloud_server.simple_server.*.ip
}
