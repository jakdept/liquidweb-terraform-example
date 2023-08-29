
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

output "instances" {
  value = liquidweb_storm_server.testing_servers.*.ip
}
