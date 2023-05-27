resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
data "yandex_compute_image" "ubuntu" {
  family = var.vpc_image_family
}

resource "yandex_compute_disk" "disks" {
  count = 3
  name  = "disk-${count.index}"
  type  = "network-hdd"
  size  = 1
  zone  = "ru-central1-a"
}

resource "yandex_compute_instance" "web_storage_host" {
  depends_on  = [yandex_compute_disk.disks]
  name        = "${local.name_web}-storage"
  platform_id = var.vm_web_platform
  resources {
    cores         = var.vm_web_resources.cores
    memory        = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks
    content {
      disk_id     = secondary_disk.value.id
      auto_delete = true
    }
  }

  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vm_web_nat
    security_group_ids = local.security_group_ids

  }
  metadata = local.vms_metadata
}

resource "local_file" "hosts_cfg" {
  depends_on = [yandex_compute_instance.db_hosts, yandex_compute_instance.web_hosts, yandex_compute_instance.web_storage_host]
  content    = templatefile("${path.module}/hosts.tftpl", { webservers = local.webservers })
  filename   = "${abspath(path.module)}/hosts.cfg"
}

resource "null_resource" "web_hosts_provision" {
  #Ждем создания инстанса
  depends_on = [yandex_compute_instance.db_hosts, yandex_compute_instance.web_hosts, yandex_compute_instance.web_storage_host]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command = "eval $(ssh-agent -s) && cat ~/.ssh/id_ed25519 | ssh-add -"
  }

  #Костыль!!! Даем ВМ время на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
  provisioner "local-exec" {
    command = "sleep 30"
  }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command     = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/hosts.cfg ${abspath(path.module)}/test.yml"
    on_failure  = continue #Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    #срабатывание триггера при изменении переменных
  }
  triggers = {
    always_run        = "${timestamp()}"                         #всегда т.к. дата и время постоянно изменяются
    playbook_src_hash = file("${abspath(path.module)}/test.yml") # при изменении содержимого playbook файла
    ssh_public_key    = local.ssh_pub_key                        # при изменении переменной
  }

}
