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
}

variable "install_script" {}
variable "install_params" {}

variable "user_data_replace_on_change" {}


