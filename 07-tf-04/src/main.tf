module "vpc_prod" {
  source   = "./vpc"
  env_name = "production"
  vpc_name = "netology"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

/*module "vpc_dev" {
  source   = "./vpc"
  env_name = "develop"
  vpc_name = "netology"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}*/


module "m_mysql_cluster" {
  depends_on = [module.vpc_prod]
  source     = "./m_mysql_cluster"
  name       = "example"
  HA         = var.mysql_cluster_ha
  subnets    = module.vpc_prod.subnets
  vpc_id     = module.vpc_prod.vpc_id
}

module "m_mysql_db" {
  depends_on       = [module.m_mysql_cluster]
  source           = "./m_mysql_db"
  mysql_cluster_id = module.m_mysql_cluster.cluster_id
  db_name          = "test"
  user_name        = "app"
  user_password    = "pass"
}

/*module "vpc_dev" {
  source   = "./vpc"
  env_name = var.default_env
  vpc_name = var.vpc_name
  zone     = var.default_zone
  cidr     = var.default_cidr
}
*/


module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = var.default_env
  network_id     = module.vpc_prod.vpc_id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [module.vpc_prod.subnets_ids[0]]
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

data "vault_generic_secret" "vault_example" {
  path = "secret/example"
}

resource "vault_mount" "kvv1" {
  path        = "kvv1"
  type        = "kv"
  options     = { version = "1" }
  description = "KV Version 1 secret engine mount"
}

resource "vault_kv_secret" "my_secret" {
  path = "${vault_mount.kvv1.path}/my_secret"
  data_json = jsonencode(
    {
      zip = "zap",
      foo = "bar"
    }
  )
}