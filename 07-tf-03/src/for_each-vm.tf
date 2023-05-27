### db hosts

resource "yandex_compute_instance" "db_hosts" {
  depends_on = [yandex_compute_instance.web_hosts]

  for_each = {
    for index, vm in var.db_hosts :
    vm.vm_name => vm
  }
  name        = "${local.name_db}-${each.value.vm_name}"
  platform_id = var.vm_db_platform
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = var.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_db_nat
  }
  metadata = local.vms_metadata
}