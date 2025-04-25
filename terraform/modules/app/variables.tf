variable "name" {
  description = "application name"
  type        = string
}
variable "tags" {
  description = "tags"
  type        = map(string)
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}
variable "vpc_cider_block" {
  description = "vpc cider block"
  type        = string
}
variable "vpc_private_subnets" {
  description = "vpc private subnets"
  type        = list(string)
}