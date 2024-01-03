terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

variable "az" {}
variable "master_ip" {}
variable "u_node_ip_prefix" {}
variable "r_node_ip_prefix" {}
variable "w_node_ip_prefix" {}
variable "master_name" {}
variable "u_node_name" {}
variable "r_node_name" {}
variable "w_node_name" {}
variable "u_nodes" { }
variable "r_nodes" {}
variable "w_nodes" {}

variable "master_ami" {
  type    = string
#  default = "ami-01d21b7be69801c2f" # ubuntu 22.04 i4i.large t2.small
  default = "ami-0c03e02984f6a0b41" # ubuntu 20.04 i4i.large t2.small
}

variable "master_type" {
  type    = string
  default = "i4i.large"
#  default = "t2.small"  # t2.large #  t2.xlarge t2.2xlarge
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

variable "user_data_replace_on_change_master" {}
variable "user_data_replace_on_change_u_node" {}
variable "user_data_replace_on_change_r_node" {}
variable "user_data_replace_on_change_w_node" {}


########################################  master ##############################################

resource "aws_instance" "master" {
  ami           = var.master_ami
  instance_type = var.master_type

  tags = {
    Name = "${var.master_name}"
  }
  
  key_name = var.keyname

  vpc_security_group_ids = [aws_security_group.main.id]

  availability_zone = var.az
  private_ip        = var.master_ip # "172.31.13.0"

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    delete_on_termination = true
  }

#  provisioner "local-exec" {
#    command = "echo \"The server's IP address is ${self.private_ip}\""
#  }

  user_data = templatefile("install-progs.sh",{})
  user_data_replace_on_change = var.user_data_replace_on_change_master 
}

########################################  ubuntu nodes ########################################

resource "aws_instance" "u_nodes" {
  ami           = var.u_node_ami
  instance_type = var.node_type
  count         = var.u_nodes
  tags = {
    Name = "${var.u_node_name}-${count.index+1}"
  }

  availability_zone = var.az
  private_ip        = "${var.u_node_ip_prefix}${count.index+1}"

  key_name = var.keyname

  vpc_security_group_ids = [aws_security_group.main.id]

#  user_data = templatefile("install-docker.sh",{})
#  user_data_replace_on_change = var.user_data_replace_on_change_u_node # true 

  depends_on = [aws_instance.master]

# connection {
#   type = "ssh"
#   host = self.public_ip
#   private_key = "/home/grtso/.ssh/ec2id_rsa"
# }
# provisioner "file" {
#   source      = "/home/grtso/.ssh/ec2id_rsa"
#   destination = "/root/.ssh/ec2id_rsa"
# }
}

########################################  redhat nodes ########################################

resource "aws_instance" "r_nodes" {
  ami           = var.r_node_ami
  instance_type = var.node_type
  count         = var.r_nodes
  tags = {
    Name = "${var.r_node_name}-${count.index+1}"
  }

  key_name = var.keyname

  vpc_security_group_ids = [aws_security_group.main.id]

  availability_zone = var.az
  private_ip        = "${var.r_node_ip_prefix}${count.index+1}"

#  user_data = templatefile("pe-install-node.sh",{master_private_dns=aws_instance.master.private_dns,node_os=var.r_node_name })
#  user_data_replace_on_change = var.user_data_replace_on_change_r_node # true 

  depends_on = [aws_instance.master]

}

########################################  window nodes ########################################

resource "aws_instance" "w_nodes" {
  
  ami           = var.w_node_ami
  instance_type = var.w_node_type
  count         = var.w_nodes
  tags = {
    Name = "${var.w_node_name}-${count.index+1}"
  }

  associate_public_ip_address = true

  key_name = var.w_keyname

  vpc_security_group_ids = [aws_security_group.main.id]

  availability_zone = var.az
  private_ip        = "${var.w_node_ip_prefix}${count.index+1}"

#  key_name = "winkey"
#  vpc_security_group_ids = ["sg-23847238474f"]
#  subnet_id     = "subnet-2348273423"

#  user_data = templatefile("pe-install-wnode.ps1",{master_private_dns=aws_instance.master.private_dns })
#  user_data_replace_on_change = var.user_data_replace_on_change_w_node

  depends_on = [aws_instance.master]

}

###############################################################################################

#resource "local_file" "inventory" {
#  filename = var.inventory
#  file_permission = "0664"
#  content = <<-EOT
#    [nodes]
#    %{ for ip in aws_instance.nodes.*.public_ip ~}
#    ${ip}
#    %{ endfor ~}
#  EOT
#}

resource "aws_security_group" "main" {
  name = "terraform-sg"
  tags = {
    name = "terraform-sw-tag"
  }
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0 
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0 # 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1" # "tcp"
      security_groups  = []
      self             = false
      to_port          = 0 #22
    }
  ]
}


resource "aws_key_pair" "key_pair" {
  key_name = "${var.keyname}"  # "ec2id_rsa"
  public_key = file("~/.ssh/ec2id_rsa.pub")
}

resource "aws_key_pair" "w_key_pair" {
  key_name = "${var.w_keyname}"  # "ec2idw_rsa"
  public_key = file("~/.ssh/ec2wid_rsa.pub")
}


output "master" {
  value = null # [aws_instance.master.public_dns, aws_instance.master.tags.Name]
}

output "nodes" {
  value = null # [aws_instance.nodes.*.public_dns, aws_instance.nodes.*.tags.Name]
}

#output "master_ssh_cmd" {
#  value = "\nssh  -o UserKnownHostsFile=/dev/null ubuntu@${aws_instance.master.public_dns}\n"
#}

output "node0_ssh_cmd" {
  value = null # var.nodes>0 ? "\nssh node0:  *****  ssh -i \"~/.ssh/ec2id_rsa\" ubuntu@${aws_instance.nodes[0].public_dns}  *****\n" : null
}

output "node1_ssh_cmd" {
  value = null # var.nodes>1 ? "\nssh node1:  *****  ssh -i \"~/.ssh/ec2id_rsa\" ubuntu@${aws_instance.nodes[1].public_dns}  *****\n" : null
}

output "node2_ssh_cmd" {
  value = null # var.nodes>2 ? "\nssh node2:  *****  ssh -i \"~/.ssh/ec2id_rsa\" ubuntu@${aws_instance.nodes[2].public_dns}  *****\n" : null
}

output "master_ssh_cmd" {
  value = ["\nssh master:     ssh -o \"StrictHostKeyChecking no\" -i \"~/.ssh/ec2id_rsa\" ubuntu@${aws_instance.master.public_dns}     "]
}

output "ssh_cmd" {
  value = null # "ssh -i \"~/.ssh/ec2id_rsa\" ubuntu@"
}

output "u_nodes_ssh_cmd" {
  value = [for node in aws_instance.u_nodes: "\nssh ${node.tags.Name}:     ssh -o \"StrictHostKeyChecking no\" -i \"~/.ssh/ec2id_rsa\" ubuntu@${node.public_dns}     "]
}

output "r_nodes_ssh_cmd" {
  value = [for node in aws_instance.r_nodes: "\nssh ${node.tags.Name}:     ssh -o \"StrictHostKeyChecking no\" -i \"~/.ssh/ec2id_rsa\" ec2-user@${node.public_dns}     "]
}
