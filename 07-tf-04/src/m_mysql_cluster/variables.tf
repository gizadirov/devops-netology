variable "HA" {
  type        = bool
  default     = false
  description = "High avail"
}

variable "name" {
  type        = string
  description = "Cluster name"
}

variable "vpc_id" {
  type        = string
  description = "Network ID"
}

variable "subnets" {
  type = list(object({
    zone = string,
    id = string
  }))
  description = "Subnets list"
}


