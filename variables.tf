variable "name" {
  description = "The name of the application"
}
variable "env" {
  description = "The environment"
}
variable "instance_type" {
  description = "The instance type"
}
variable "vpc_id" {
  description = "The vpc id"
}
variable "subnet" {
  description = "The subnet name"
}
variable "delete_logs_on_terminate" {
  default = "true"
}
variable "stream_logs" {
  default = "true"
}

variable "key_name" {
  description = "The key pair name"
}
