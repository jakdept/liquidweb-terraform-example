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

  lifecycle {
    create_before_destroy = false
  }

  connection {
    type  = "ssh"
    user  = "root"
    agent = true
    host  = self.ip
  }

  provisioner "remote-exec" {
    inline = [
      "yum install -y epel-release",
      "yum install -y http://rpms.remirepo.net/enterprise/remi-release-8.rpm",
      "yum install -y wget curl nginx mysql mysql-common mysql-server php82-php-fpm php82-php-mysqlnd php82-php-mbstring"
    ]
  }

  provisioner "file" {
    content     = data.template_file.site-conf.rendered
    destination = "/etc/nginx/conf.d/site.conf"
  }
  provisioner "file" {
    content     = data.template_file.php-conf.rendered
    destination = "/etc/opt/remi/php82/php-fpm.d/site.conf"
  }
  provisioner "file" {
    content     = data.template_file.create-database.rendered
    destination = "/root/create-database.sql"
  }
  provisioner "file" {
    content     = data.template_file.install-wordpress.rendered
    destination = "/root/install-wordpress.sh"
  }
  provisioner "file" {
    content     = data.template_file.wp-config.rendered
    destination = "/root/wp-config.php"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl start mysqld.service",
      "chmod +x /root/install-wordpress.sh",
      "/root/install-wordpress.sh",
      "mysql < /root/create-database.sql",
      "systemctl enable nginx.service php82-php-fpm.service mysqld.service",
      "systemctl start nginx.service php82-php-fpm.service mysqld.service",
      "firewall-cmd --zone public --permanent --add-port 80/tcp",
      "firewall-cmd --zone public --permanent --add-port 443/tcp",
      "firewall-cmd --reload"
    ]
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
