###cloud vars

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vpc_project" {
  type        = string
  default     = "netology"
  description = "VPC project name"
}

variable "vpc_platform" {
  type        = string
  default     = "platform"
  description = "VPC platform"
}

variable "vpc_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Yandex compute instance image family name"
}

variable "vpc_serial_port_enable" {
  type    = number
  default = 1
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUn/gGWFr/1blOlmnF+dumLV/7SoU1t+5JbAPzfWZ16 timur@LAPTOP-D947D6IL"
  description = "ssh-keygen -t ed25519"
}
variable "vms_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "ssh user"
}

### env

variable "env" {
  type        = map(any)
  default     = { "development" = "development", "stage" = "stage", "production" = "production" }
  description = "Environment"
}