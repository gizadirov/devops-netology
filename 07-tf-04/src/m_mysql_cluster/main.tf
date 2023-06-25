locals {
  subnets = { for i, e in slice(var.subnets, 0, var.HA ? 3 : 1) : i => e }
}

resource "yandex_mdb_mysql_cluster" "mysql" {
  name                = var.name
  environment         = "PRESTABLE"
  network_id          = var.vpc_id
  version             = "8.0"
  deletion_protection = false

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-hdd"
    disk_size          = 10
  }

  dynamic "host" {
    for_each = local.subnets
    content {
      zone      = host.value.zone
      subnet_id = host.value.id
    }
  }
}
