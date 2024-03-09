resource "yandex_vpc_network" "vpc" {
  name = "netology"
}

resource "yandex_vpc_subnet" "public_net" {
  depends_on     = [yandex_vpc_network.vpc]
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "nat" {
  depends_on  = [yandex_vpc_subnet.public_net]
  name        = "netology-nat"
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public_net.id
    nat        = true
    ip_address = "192.168.10.254"

  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }

}

output "nat_ip" {
  value = yandex_compute_instance.nat.network_interface.0.nat_ip_address
}

resource "yandex_vpc_route_table" "nat_instance_route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}

resource "yandex_vpc_subnet" "private_net" {
  depends_on     = [yandex_vpc_network.vpc, yandex_vpc_route_table.nat_instance_route]
  name           = "private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat_instance_route.id
}

resource "yandex_compute_instance" "node1" {
  depends_on  = [yandex_vpc_subnet.private_net]
  name        = "netology-node1"
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ba9d5mfvlncknt2kd"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_net.id
    nat       = false
  }

  metadata = {
    user-data          = "${file("meta.txt")}"
  }

}

