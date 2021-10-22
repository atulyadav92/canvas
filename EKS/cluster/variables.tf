variable "name" {
  default = {}
}
variable "cidr" {
  default = {}
}
variable "sbn_cidr_pbl" {
  type = list(string)
  default = []
}
variable "sbn_cidr_pvt" {
  type = list(string)
  default = []
}
variable "cluster_name" {
  default = {}
}
variable "account_id" {
  default = {}
}
variable "subnet_pvt" {
  default = {}
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
variable "profile" {
  default = {}
}
variable "region" {
  default = {}
}