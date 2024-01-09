
resource "local_file" "inventory" {
  filename = "inventory.ini"
  file_permission = "0664"
  content = <<-EOT
    [nodes]
    ${length(module.master)}
    %{for v in module.master ~}
${v.public_ip}
    %{ endfor ~}
  EOT
}

#    %{ for ip in aws_instance.nodes.*.public_ip ~}
