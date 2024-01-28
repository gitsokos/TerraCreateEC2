resource "aws_instance" "ec2instance" {
  ami           = var.ami
  instance_type = var.type

  tags = {
    Name = "${var.name}"
  }
  
  key_name = var.key_name

  vpc_security_group_ids = var.vpc_security_group_ids

  availability_zone = var.az
  private_ip        = var.private_ip

  root_block_device {
    volume_size           = var.root_block_device.volume_size
    volume_type           = var.root_block_device.volume_type
    delete_on_termination = var.root_block_device.delete_on_termination
  }


  user_data = var.install_script==""?"":templatefile(var.install_script,var.install_params)
  user_data_replace_on_change = var.user_data_replace_on_change

}

