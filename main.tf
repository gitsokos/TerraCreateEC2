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

####################################### master ###############################################

module "master" {
  source = "./modules/ec2"

  for_each = var.master

  ami                         = each.value.ami
  type                        = each.value.type
  name                        = each.value.name
  key_name                    = each.value.key_name
  az                          = each.value.az
  install_script              = each.value.install_script
  install_params              = each.value.install_params
  user_data_replace_on_change = each.value.user_data_replace_on_change
  private_ip                  = each.value.private_ip
  root_block_device           = each.value.root_block_device

  vpc_security_group_ids      = [aws_security_group.main.id]
}

########################################  ubuntu nodes ########################################

module "unodes" {
  source = "./modules/ec2"

  for_each = var.unodes

  ami                         = each.value.ami
  type                        = each.value.type
  name                        = each.value.name
  key_name                    = each.value.key_name
  az                          = each.value.az
  install_script              = each.value.install_script
  install_params              = each.value.install_params
  user_data_replace_on_change = each.value.user_data_replace_on_change
  private_ip                  = each.value.private_ip
  root_block_device           = each.value.root_block_device

  vpc_security_group_ids      = [aws_security_group.main.id]

  depends_on = [module.master]
}

########################################  redhat nodes ########################################

module "rnodes" {
  source = "./modules/ec2"

  for_each = var.rnodes

  ami                         = each.value.ami
  type                        = each.value.type
  name                        = each.value.name
  key_name                    = each.value.key_name
  az                          = each.value.az
  install_script              = each.value.install_script
  install_params              = each.value.install_params
  user_data_replace_on_change = each.value.user_data_replace_on_change
  private_ip                  = each.value.private_ip
  root_block_device           = each.value.root_block_device

  vpc_security_group_ids      = [aws_security_group.main.id]

  depends_on = [module.master]
}

########################################  window nodes ########################################

module "wnodes" {
  source = "./modules/ec2"

  for_each = var.wnodes

  ami                         = each.value.ami
  type                        = each.value.type
  name                        = each.value.name
  key_name                    = each.value.key_name
  az                          = each.value.az
  install_script              = each.value.install_script
  install_params              = each.value.install_params
  user_data_replace_on_change = each.value.user_data_replace_on_change
  private_ip                  = each.value.private_ip
  root_block_device           = each.value.root_block_device

  vpc_security_group_ids      = [aws_security_group.main.id]

  depends_on = [module.master]
}

###############################################################################################

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

