az = "eu-west-3a"

u_nodes = 0
r_nodes = 0
w_nodes = 0
user_data_replace_on_change_master = true # false
user_data_replace_on_change_u_node = true # false
user_data_replace_on_change_r_node = true # false
user_data_replace_on_change_w_node = true # false


master_ip        = "172.31.13.0"
u_node_ip_prefix = "172.31.13.10"
r_node_ip_prefix = "172.31.13.15"
w_node_ip_prefix = "172.31.13.20"

master_name = "master"
u_node_name = "ubuntu"
r_node_name = "redhat"
w_node_name = "window"


master_ami = "ami-0c03e02984f6a0b41" # ubuntu 20.04 i4i.large t2.small
#master_ami = "ami-01d21b7be69801c2f" # ubuntu 22.04 i4i.large t2.small

master_type = "t2.medium"  # t2.large #  t2.xlarge t2.2xlarge - "i4i.large"

u_node_ami = "ami-0c03e02984f6a0b41" # ubuntu 20.04 i4i.large t2.small
#u_node_ami = "ami-01d21b7be69801c2f" # ubuntu 22.04 i4i.large t2.small

r_node_ami = "ami-0d767e966f3458eb5"

node_type = "t2.small"  # t2.large #  t2.xlarge t2.2xlarge

w_node_ami = "ami-0ba8ace2a2638cb1b"

w_node_type = "t2.small"

keyname = "ec2id_rsa"

w_keyname = "ec2wid_rsa"


configs = {
  master1 = {
    ami                         = "ami-01d21b7be69801c2f"
    type                        = "t2.medium"
    private_ip                  = "172.31.13.1"
    name                        = "master1"
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
}


