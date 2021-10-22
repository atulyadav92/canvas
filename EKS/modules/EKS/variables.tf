variable "vpc_id" {
  default = {}
}
variable "cluster_name" {
  default = {}
}
variable "account_id" {
  default = {}
}
variable "subnet_pvt" {
  type = list(string)
  default = []
}
variable "desired_size" {
  default = {}
}
variable "max_size" {
  default = {}
}
variable "min_size" {
  default = {}
}
variable "k8s_version" {
  default = {}
}