/*
variable "zone" {
  type        = string
  default     = null
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "cidr" {
  type        = list(string)
  default     = null
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}
*/

variable "vpc_name" {
  type        = string
  description = "VPC network&subnet name"
}

variable "env_name" {
  type        = string
  description = "Environment"
}

variable "subnets" {
  type = list(object({
    zone = string,
    cidr = string
  }))
  description = "Subnets list"
}


