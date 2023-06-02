output "vpc_id" {
  value       = yandex_vpc_network.vpc.id
  description = "VPC network ID"
}

output "subnet_id" {
  value       = yandex_vpc_subnet.subnet.id
  description = "VPC subnet ID"
}
