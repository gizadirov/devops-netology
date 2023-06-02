output "vpc_id" {
  value       = yandex_vpc_network.vpc.id
  description = "VPC network ID"
}

### Задание 2
/*output "subnet_id" {
  value       = yandex_vpc_subnet.subnet.id
  description = "VPC subnet ID"
}*/

output "subnets_ids" {
  value       = [for k, v in yandex_vpc_subnet.subnets : v.id]
  description = "VPC subnets IDs"
}