
keyname = "ec2id_rsa"

w_keyname = "ec2wid_rsa"


master = {
  master1 = {
    ami                         = "ami-01d21b7be69801c2f"
    type                        = "t2.medium"
    private_ip                  = "172.31.13.1"
    name                        = "master1"
    key_name                    = "ec2id_rsa"
    az                          = "eu-west-3a"
    install_script              = ""
    install_params              = {}
    user_data_replace_on_change = true
    root_block_device  = {
      volume_size               = "16"
      volume_type               = "gp2"
      delete_on_termination     = true
    }
  },
/*************************************************
  master2 = {
    ami                         = "ami-01d21b7be69801c2f"
    type                        = "t2.small"
    private_ip                  = "172.31.13.2"
    name                        = "master2"
    key_name                    = "ec2id_rsa"
    az                          = "eu-west-3a"
    install_script              = "install-progs.sh"
    install_params              = {}
    user_data_replace_on_change = true
    root_block_device  = {
      volume_size               = "20"
      volume_type               = "gp2"
      delete_on_termination     = true
    }
  },
*************************************************/
}


unodes = {
/*************************************************
  ubuntu1 = {
    ami                         = "ami-01d21b7be69801c2f"
    type                        = "t2.medium"
    private_ip                  = "172.31.13.11"
    name                        = "ubuntu1"
    key_name                    = "ec2id_rsa"
    az                          = "eu-west-3a"
    install_script              = "install-progs.sh"
    install_params              = {}
    user_data_replace_on_change = true
    root_block_device  = {
      volume_size               = "16"
      volume_type               = "gp2"
      delete_on_termination     = true
    }
  },
  ubuntu2 = {
    ami                         = "ami-01d21b7be69801c2f"
    type                        = "t2.small"
    private_ip                  = "172.31.13.12"
    name                        = "ubuntu2"
    key_name                    = "ec2id_rsa"
    az                          = "eu-west-3a"
    install_script              = "install-progs.sh"
    install_params              = {}
    user_data_replace_on_change = true
    root_block_device  = {
      volume_size               = "20"
      volume_type               = "gp2"
      delete_on_termination     = true
    }
  },
*************************************************/
}

rnodes = {
/*************************************************
  redhat1 = {
    ami                         = "ami-0d767e966f3458eb5"
    type                        = "t2.medium"
    private_ip                  = "172.31.13.21"
    name                        = "redhat1"
    key_name                    = "ec2id_rsa"
    az                          = "eu-west-3a"
    install_script              = "install-progs.sh"
    install_params              = {}
    user_data_replace_on_change = true
    root_block_device  = {
      volume_size               = "16"
      volume_type               = "gp2"
      delete_on_termination     = true
    }
  },
  redhat2 = {
    ami                         = "ami-0d767e966f3458eb5"
    type                        = "t2.small"
    private_ip                  = "172.31.13.22"
    name                        = "redhat2"
    key_name                    = "ec2id_rsa"
    az                          = "eu-west-3a"
    install_script              = "install-progs.sh"
    install_params              = {}
    user_data_replace_on_change = true
    root_block_device  = {
      volume_size               = "20"
      volume_type               = "gp2"
      delete_on_termination     = true
    }
  },
*************************************************/
}

wnodes = {
/*************************************************
  window1 = {
    ami                         = "ami-0ba8ace2a2638cb1b"
    type                        = "t2.medium"
    private_ip                  = "172.31.13.31"
    name                        = "window1"
    key_name                    = "ec2wid_rsa"
    az                          = "eu-west-3a"
    install_script              = "install-progs.ps1"
    install_params              = {}
    user_data_replace_on_change = true
    root_block_device  = {
      volume_size               = "32"
      volume_type               = "gp2"
      delete_on_termination     = true
    }
  },
  window2 = {
    ami                         = "ami-0ba8ace2a2638cb1b"
    type                        = "t2.small"
    private_ip                  = "172.31.13.32"
    name                        = "window2"
    key_name                    = "ec2wid_rsa"
    az                          = "eu-west-3a"
    install_script              = "install-progs.ps1"
    install_params              = {}
    user_data_replace_on_change = true
    root_block_device  = {
      volume_size               = "32"
      volume_type               = "gp2"
      delete_on_termination     = true
    }
  },
*************************************************/
}

