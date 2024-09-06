variable "service_name" {
  description = "The name of the Cloudmap service discovery"
  type        = string
}

variable "record_type" {
  description = "The DNS record type to create"
  type        = string
  default = "A"
}

variable "record_ttl" {
  description = "The TTL of the DNS record"
  type        = number
  default = 60
}
