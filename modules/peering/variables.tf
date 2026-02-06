variable "hub" {
  type = object({
    name                = string
    id                  = string
    resource_group_name = string
  })
}

variable "spoke" {
  type = object({
    name                = string
    id                  = string
    resource_group_name = string
  })
}

variable "allow_forwarded_traffic" {
  type    = bool
  default = true
}

variable "allow_gateway_transit" {
  type    = bool
  default = false
}

variable "use_remote_gateways" {
  type    = bool
  default = false
}
