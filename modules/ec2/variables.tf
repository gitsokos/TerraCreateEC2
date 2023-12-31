variable "ami" {}
variable "type" {}

variable "name" {}
  
variable "key_name" {}

variable "vpc_security_group_ids" {}

variable "az" {}
variable "private_ip" {}

variable "root_block_device" {
  type = object(
    {
      volume_size           = string
      volume_type           = string
      delete_on_termination = bool
    }
  )
  default = {
    volume_size           = "20"
    volume_type           = "gp2"
    delete_on_termination = true
  }
}


variable "install_script" {}
variable "install_params" {}

variable "user_data_replace_on_change" {}


