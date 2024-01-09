variable "keyname" {
  type    = string
  default = "ec2id_rsa"
}

variable "w_keyname" {
  type    = string
  default = "ec2wid_rsa"
}


variable "master" {
  type = map ( object (
    {
      ami                         = string
      type                        = string
      private_ip                  = string
      name                        = string
      key_name                    = string
      az                          = string
      install_script              = string
      install_params              = any
      user_data_replace_on_change = bool

      root_block_device = object (
        {
          volume_size           = string
          volume_type           = string
          delete_on_termination = bool
        }
      )
    }
  ))
}

variable "unodes" {
  type = map ( object (
    {
      ami                         = string
      type                        = string
      private_ip                  = string
      name                        = string
      key_name                    = string
      az                          = string
      install_script              = string
      install_params              = any
      user_data_replace_on_change = bool

      root_block_device = object (
        {
          volume_size           = string
          volume_type           = string
          delete_on_termination = bool
        }
      )
    }
  ))
}

variable "rnodes" {
  type = map ( object (
    {
      ami                         = string
      type                        = string
      private_ip                  = string
      name                        = string
      key_name                    = string
      az                          = string
      install_script              = string
      install_params              = any
      user_data_replace_on_change = bool

      root_block_device = object (
        {
          volume_size           = string
          volume_type           = string
          delete_on_termination = bool
        }
      )
    }
  ))
}

variable "wnodes" {
  type = map ( object (
    {
      ami                         = string
      type                        = string
      private_ip                  = string
      name                        = string
      key_name                    = string
      az                          = string
      install_script              = string
      install_params              = any
      user_data_replace_on_change = bool

      root_block_device = object (
        {
          volume_size           = string
          volume_type           = string
          delete_on_termination = bool
        }
      )
    }
  ))
}

