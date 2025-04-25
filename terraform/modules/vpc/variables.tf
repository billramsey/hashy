variable "name" {
  description = "application name"
  type        = string
}
variable "tags" {
  description = "tags"
  type        = map(string)
}
variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
}
variable "azs" {
  description = "azs"
  type        = list(string)
}
