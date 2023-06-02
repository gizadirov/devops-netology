module "vpc_dev" {
  source   = "./vpc"
  env_name = var.default_env
  vpc_name = var.vpc_name
  zone     = var.default_zone
  cidr     = var.default_cidr
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = var.default_env
  network_id     = module.vpc_dev.vpc_id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [ module.vpc_dev.subnet_id ]
  instance_name  = "web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    "ssh_key" = file("~/.ssh/id_ed25519.pub")
  }
}

