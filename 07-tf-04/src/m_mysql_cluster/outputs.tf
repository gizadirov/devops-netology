output "cluster_id" {
  value       = yandex_mdb_mysql_cluster.mysql.id
  description = "MySQL cluster ID"
}

output "cluster_hosts" {
  value = [for i, e in yandex_mdb_mysql_cluster.mysql.host : { fqdn = e.fqdn }]
}

