output "instance_1_ip" {
  value = aws_instance.ec2-instance["instance1"].private_ip
}

output "instance_2_ip" {
  value = aws_instance.ec2-instance["instance2"].private_ip
}

output "bastion_public_ip" {
  value = aws_eip.eip_bastion.public_ip
}

output "instance_1_root_password" {
  value = random_password.ec2_root_password["instance1"].result
  sensitive = true
}

output "instance_2_root_password" {
  value = random_password.ec2_root_password["instance2"].result
  sensitive = true
}

output "ec2_ssh_private_key" {
  value     = tls_private_key.private_key.private_key_pem
  sensitive = true
}
