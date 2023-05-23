locals {
  name_web = "${var.vpc_project}-${var.env.development}-${var.vpc_platform}-${var.vm_web_suffix}"
  name_db  = "${var.vpc_project}-${var.env.development}-${var.vpc_platform}-${var.vm_db_suffix}"

  ### VPC metadata
  vpc_metadata = {
    serial-port-enable = var.vpc_serial_port_enable,
    ssh-keys           = "${var.vms_ssh_user}:${var.vms_ssh_root_key}"
  }
}

