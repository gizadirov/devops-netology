output "vm_web_ip" {
  value = yandex_compute_instance.platform.network_interface[0].nat_ip_address
}

output "vm_db_ip" {
  value = yandex_compute_instance.platform1.network_interface[0].nat_ip_address
}