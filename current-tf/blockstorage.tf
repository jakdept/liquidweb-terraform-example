resource "liquidweb_storage_block_volume" "testing_block_volume" {
  domain = "block_volume.terraform-testing.api.jakdept.dev"
  size   = 10
}

output "block_storage" {
  value = liquidweb_storage_block_volume.testing_block_volume.domain
}
