variable "name" {}
variable "env" {}
variable "vpc_id" {}
variable "cert_arn" {}
variable "public_subnet_id" {}
variable "instance_type" {}
variable "delete_logs_on_terminate" {
  default = "false"
}
variable "key_pair_name" {}
