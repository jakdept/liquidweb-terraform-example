
terraform {
  required_providers {
    liquidweb = {
      source  = "local.providers/liquidweb/liquidweb"
      version = "~> 1.6.2"
    }
  }
}

resource "random_id" "server" {
  byte_length = 1
  # count       = 1
}

resource "random_password" "server" {
  length  = 20
  special = false
}

resource "random_password" "wordpress_dbpass" {
  length  = 20
  special = true
}

data "liquidweb_network_zone" "zonec" {
  name        = "Zone C"
  region_name = "US Central"
}

data "template_file" "wp-config" {
  template = file("${path.module}/templates/wp-config.php")
  vyamlars = {
    dbhost = var.wordpress_dbhost
    dbname = var.wordpress_dbname
    dbuser = var.wordpress_dbuser
    dbpass = random_password.wordpress_dbpass.result
  }
}

data "template_file" "create-database" {
  template = file("${path.module}/templates/create-database.sql")
  vyamlars = {
    dbhost = var.wordpress_dbhost
    dbname = var.wordpress_dbname
    dbuser = var.wordpress_dbuser
    dbpass = random_password.wordpress_dbpass.result
  }
}

data "template_file" "init-script" {
  template = file("${path.module}/templates/site.conf")
  vyamlars = {
    domain = var.site_name
  }
}
