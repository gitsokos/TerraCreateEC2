
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

output "ssh_cmd" {
  value = null # "ssh -i \"~/.ssh/ec2id_rsa\" ubuntu@"
}

output "u_nodes_ssh_cmd" {
  value = [for node in aws_instance.u_nodes: "\nssh ${node.tags.Name}:     ssh -o \"StrictHostKeyChecking no\" -i \"~/.ssh/ec2id_rsa\" ubuntu@${node.public_dns}     "]
}

output "r_nodes_ssh_cmd" {
  value = [for node in aws_instance.r_nodes: "\nssh ${node.tags.Name}:     ssh -o \"StrictHostKeyChecking no\" -i \"~/.ssh/ec2id_rsa\" ec2-user@${node.public_dns}     "]
}

output "master_ssh_cmd" {
#  value = ["\nssh master:     ssh -o \"StrictHostKeyChecking no\" -i \"~/.ssh/ec2id_rsa\" ubuntu@${aws_instance.master.public_dns}     "]
  value = [for v in module.master:"\nssh -o \"StrictHostKeyChecking no\" -i \"~/.ssh/ec2id_rsa\" ubuntu@${v.public_dns}"]
#  value = [for v in module.master: "${v.public_dns}"]
#  value = module.master.master1 #public_ip
}
