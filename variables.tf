variable "az" {}

variable "u_nodes" { }
variable "r_nodes" {}
variable "w_nodes" {}
variable "user_data_replace_on_change_master" {}
variable "user_data_replace_on_change_u_node" {}
variable "user_data_replace_on_change_r_node" {}
variable "user_data_replace_on_change_w_node" {}

variable "master_ip" {}
variable "u_node_ip_prefix" {}
variable "r_node_ip_prefix" {}
variable "w_node_ip_prefix" {}

variable "master_name" {}
variable "u_node_name" {}
variable "r_node_name" {}
variable "w_node_name" {}

variable "master_ami" {
  type    = string
#  default = "ami-01d21b7be69801c2f" # ubuntu 22.04 i4i.large t2.small
  default = "ami-0c03e02984f6a0b41" # ubuntu 20.04 i4i.large t2.small
}

variable "master_type" {
  type    = string
#  default = "i4i.large"
  default = "t2.medium"  # t2.large #  t2.xlarge t2.2xlarge
}

variable "u_node_ami" {
  type    = string
#  default = "ami-01d21b7be69801c2f" # ubuntu 22.04 i4i.large t2.small
  default = "ami-0c03e02984f6a0b41" # ubuntu 20.04 i4i.large t2.small
}

variable "r_node_ami" {
  type    = string
  default = "ami-0d767e966f3458eb5"
}

variable "node_type" {
  type    = string
  default = "t2.small"  # t2.large #  t2.xlarge t2.2xlarge
}

variable "w_node_ami" {
  type    = string
  default = "ami-0ba8ace2a2638cb1b"
}

variable "w_node_type" {
  type    = string
  default = "t2.small"
}

variable "keyname" {
  type    = string
  default = "ec2id_rsa"
}

variable "w_keyname" {
  type    = string
  default = "ec2wid_rsa"
}

