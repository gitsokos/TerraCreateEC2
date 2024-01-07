resource "aws_instance" "ec2instance" {
  ami           = var.ami
  instance_type = var.type

  tags = {
    Name = "${var.name}"
  }
  
  key_name = var.key_name

  vpc_security_group_ids = var.vpc_security_group_ids

  availability_zone = var.az
  private_ip        = var.private_ip # "172.31.13.0"

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }


#  user_data = templatefile("install-progs.sh",{})
  user_data = templatefile(var.install_script,var.install_params)
  user_data_replace_on_change = var.user_data_replace_on_change

}
