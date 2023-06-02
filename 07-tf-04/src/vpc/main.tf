resource "yandex_vpc_network" "vpc" {
  name = "${var.vpc_name}_${var.env_name}_net"
}

resource "yandex_vpc_subnet" "subnets" {
  for_each       = { for i, e in var.subnets : i => e }
  name           = "${var.vpc_name}_${var.env_name}_${each.key}_subnet"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [ each.value.cidr ]
}

