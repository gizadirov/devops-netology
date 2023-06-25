resource "yandex_mdb_mysql_database" "db" {
  cluster_id = var.mysql_cluster_id
  name       = var.db_name
}

resource "yandex_mdb_mysql_user" "db_user" {
  depends_on = [yandex_mdb_mysql_database.db]
  cluster_id = var.mysql_cluster_id
  name       = var.user_name
  password   = var.user_password
  permission {
    database_name = var.db_name
    roles         = ["ALL"]
  }
}