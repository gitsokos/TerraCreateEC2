
output "master_ssh_cmd" {
  value = [for v in module.master:"\nssh -o \"StrictHostKeyChecking no\" -i \"~/.ssh/ec2id_rsa\" ubuntu@${v.public_dns}"]
}

output "ubuntu_ssh_cmd" {
  value = [for v in module.unodes:"\nssh -o \"StrictHostKeyChecking no\" -i \"~/.ssh/ec2id_rsa\" ubuntu@${v.public_dns}"]
}

output "redhat_ssh_cmd" {
  value = [for v in module.rnodes:"\nssh -o \"StrictHostKeyChecking no\" -i \"~/.ssh/ec2id_rsa\" ec2-user@${v.public_dns}"]
}

