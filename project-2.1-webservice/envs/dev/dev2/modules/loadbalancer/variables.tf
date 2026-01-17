variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }
variable "lb_name" { type = string }
