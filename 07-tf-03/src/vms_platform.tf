### vm_web vars

variable "vm_web_suffix" {
  type    = string
  default = "web"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Yandex compute instance name"
}

variable "vm_web_platform" {
  type        = string
  default     = "standard-v1"
  description = "Yandex compute instance platform"
}

variable "vm_web_resources" {
  type = map(any)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  description = "Yandex compute instance web resources"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Yandex compute instance web preemptible"
}

variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "Yandex compute instance web nat"
}
### vm_storage

### vm_db vars

variable "vm_db_suffix" {
  type    = string
  default = "db"
}

variable "vm_db_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Yandex compute instance db image family name"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Yandex compute instance db name"
}

variable "vm_db_platform" {
  type        = string
  default     = "standard-v1"
  description = "Yandex compute instance db platform"
}

variable "db_hosts" {
  type = list(object({
    vm_name = string,
    cpu     = number,
    ram     = number,
    disk    = number
  }))
  default = [
    {
      vm_name = "main",
      cpu     = 4,
      ram     = 4,
      disk    = 5
    },
    {
      vm_name = "replica",
      cpu     = 2,
      ram     = 2,
      disk    = 6
    }
  ]
}

variable "vm_db_resources" {
  type = map(any)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  description = "Yandex compute instance db resources"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "Yandex compute instance db preemptible"
}

variable "vm_db_nat" {
  type        = bool
  default     = true
  description = "Yandex compute instance db nat"
}

