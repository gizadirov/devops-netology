locals {
  name_web = "${var.vpc_project}-${var.env.development}-${var.vpc_platform}-${var.vm_web_suffix}"
  name_db  = "${var.vpc_project}-${var.env.development}-${var.vpc_platform}-${var.vm_db_suffix}"
  ssh_pub_key = file("~/.ssh/id_ed25519.pub")
  ### VMS metadata
  vms_metadata = {
    serial-port-enable = var.vpc_serial_port_enable,
    ssh-keys           = "${var.vms_ssh_user}:${local.ssh_pub_key}"
  }
  security_group_ids = [ yandex_vpc_security_group.example.id ]
  webservers =  flatten([
    yandex_compute_instance.web_hosts[*],
    [for i, e in yandex_compute_instance.db_hosts : e],
    yandex_compute_instance.web_storage_host,
  ])
}

