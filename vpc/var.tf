variable "cidr_block" {
  description = "CIDR block for the VPC. Must be at least /28 size."
  type        = "string"
}

variable "tag_block" {
  type    = "map(string)"
  default = {}
}

variable "dns_support" {
  description = "Enables vpc DNS Support. Defaults to true."
  default     = true
  type        = "bool"
}
