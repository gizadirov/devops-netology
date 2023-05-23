### vm_web vars

variable "vm_web_suffix" {
  type    = string
  default = "web"
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

### vm_db vars

variable "vm_db_suffix" {
  type    = string
  default = "db"
}

variable "vm_db_platform" {
  type        = string
  default     = "standard-v1"
  description = "Yandex compute instance db platform"
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

