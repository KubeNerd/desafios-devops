output "public_ip" {
  value = "IP Público: ${aws_instance.web.public_ip}"
}

output "my_ip" {
  value = "Meu IP: ${local.my_ip_with_cidr}"
}