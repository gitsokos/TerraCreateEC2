
resource "local_file" "inventory" {
  filename = "inventory.ini"
  file_permission = "0664"
  content = <<EOT
    %{~if length(module.master)>0 ~}
      [master]
      %{~for v in module.master ~}
      ${v.public_ip}	ansible_connection=ssh  ansible_user=ubuntu     ansible_ssh_private_key_file=~/.ssh/ec2id_rsa
      %{~endfor ~}
    %{~endif ~}

    %{~if length(module.unodes)>0 ~}
      [unodes]
      %{~for v in module.unodes ~}
      ${v.public_ip}
      %{~ endfor ~}
    %{~endif ~}

    %{~if length(module.rnodes)>0 ~}
      [rnodes]
      %{~for v in module.rnodes ~}
      ${v.public_ip}
      %{~ endfor ~}
    %{~endif ~}

    %{~if length(module.wnodes)>0 ~}
      [wnodes]
      %{~for v in module.wnodes ~}
      ${v.public_ip}
      %{~ endfor ~}
    %{~endif ~}

  EOT
}

#    %{ for ip in aws_instance.nodes.*.public_ip ~}
