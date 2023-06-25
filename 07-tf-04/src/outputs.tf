output "mysql_cluster_hosts" {
  value = module.m_mysql_cluster.cluster_hosts
}
output "test_vm_ip" {
  value = module.test-vm.external_ip_address
}
output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
}
output "vault_my_secret" {
 value = "${nonsensitive(vault_kv_secret.my_secret.data_json)}"
}
