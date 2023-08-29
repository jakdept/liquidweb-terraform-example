resource "liquidweb_network_dns_record" "testing_a_record" {
  name  = "dns.terraform-testing.api.domain.jakdept.dev"
  type  = "A"
  rdata = "127.0.0.1"
  zone  = "dns.terraform-testing.api.jakdept.dev"
}

output "domain_a_name" {
  value = liquidweb_network_dns_record.testing_a_record.name
}
