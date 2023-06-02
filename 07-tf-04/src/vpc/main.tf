resource "yandex_vpc_network" "vpc" {
  name = "${var.vpc_name}_${var.env_name}_net"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "${var.vpc_name}_${var.env_name}_subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.cidr]
}


