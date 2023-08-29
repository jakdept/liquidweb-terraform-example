resource "liquidweb_storage_block_volume" "testing_block_volume" {
  domain = "terraform-block${random_id.block.dec}.us-midwest-2.hostbaitor.com"
  size   = 10
}

output "block_storage" {
  value = liquidweb_storage_block_volume.testing_block_volume.domain
}
