variable "name" {}
variable "env" {}
variable "instance_type" {}
variable "vpc_id" {}
variable "subnet" {}
variable "delete_logs_on_terminate" {
  default = "true"
}
variable "stream_logs" {
  default = "true"
}
