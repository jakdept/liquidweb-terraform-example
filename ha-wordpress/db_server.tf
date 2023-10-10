resource "liquidweb_cloud_server" "db_server" {
  count = 3

  #config_id = "${data.liquidweb_storm_server_config.api.id}"
  config_id = 1757
  zone      = data.liquidweb_network_zone.zonec.network_zone_id
  #data.liquidweb_network_zone.api.id
  template       = "ROCKYLINUX_8_UNMANAGED"
  domain         = "wpcluster-db${count.index}-p${random_id.server.dec}.us-midwest-2.${var.top_domain}"
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
      "yum install -y wget curl mysql",
      "curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh",
      "source /root/.bash_profile",
      "tiup cluster"
    ]
  }
}

output "instances" {
  value = liquidweb_cloud_server.db_server.*.ip
}
