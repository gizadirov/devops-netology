output "vpc_id" {
  value       = yandex_vpc_network.vpc.id
  description = "VPC network ID"
}

output "subnets_ids" {
  value       = [for k, v in yandex_vpc_subnet.subnets : v.id]
  description = "VPC subnets IDs"
}