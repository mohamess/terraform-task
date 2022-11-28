output "instances_ips" {
    value = {
    for k, pip in aws_instance.ec2-instance : k => pip.private_ip
    }
}

output "bastion_public_ip" {
  value = aws_eip.eip_bastion.public_ip
}

output "root_passwords" {
  value = {
  for k, pw in random_password.ec2_root_password : k => pw.result
  }
  sensitive = true
}

output "ec2_ssh_private_key" {
  value     = tls_private_key.private_key.private_key_pem
  sensitive = true
}

output "ping_status" {
  value = data.external.external_ping_status.result
}
