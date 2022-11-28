locals {
  number_of_instances=length(var.ec2_instances)
  list_of_instances_ips=join (",", [for pip in aws_instance.ec2-instance : pip.private_ip])
}

resource "random_password" "ec2_root_password" {
  for_each = var.ec2_instances

  length           = var.root_password_length
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-task-key"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "aws_instance" "bastion_host" {
  subnet_id       = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.allow_ssh_bastion.id]
  ami           = var.ec2_bastion["instance_ami"]
  instance_type = var.ec2_bastion["instance_type"]
  key_name      = aws_key_pair.generated_key.key_name
  tags = {
    Name = var.ec2_bastion["instance_name"]
    application = var.application
    environment = var.environment
  }
}

resource "aws_instance" "ec2-instance" {
  for_each        = var.ec2_instances
  subnet_id       = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.allow_ssh_ping.id]
  ami             = each.value["instance_ami"]
  instance_type   = each.value["instance_type"]
  key_name        = aws_key_pair.generated_key.key_name
  user_data = <<EOF
                #!/bin/bash
                rootpw = "${random_password.ec2_root_password[each.key].result}"
                echo root:$rootpw | chpasswd
              EOF
  tags = {
    Name = each.value["instance_name"]
    application = var.application
    environment = var.environment
  }
}


#resource "null_resource" "ping_instance1" {
#  provisioner "remote-exec" {
#    inline = [
#      "ssh -o 'StrictHostKeyChecking no' ubuntu@${aws_instance.ec2-instance["instance2"].private_ip} << EOF",
#      "ping -q -c 1  ${aws_instance.ec2-instance["instance1"].private_ip} 2>&1 > /dev/null && echo SUCCESS || echo FAILED",
#      "EOF"
#    ]
#    connection {
#      type = "ssh"
#      user = "ubuntu"
#      private_key = tls_private_key.private_key.private_key_pem
#      host = aws_instance.bastion_host.public_ip
#      timeout = "10s"
#    }
#  }
#}
#
#resource "null_resource" "ping_instance2" {
#  provisioner "remote-exec" {
#    inline = [
#      "ssh -o 'StrictHostKeyChecking no' ubuntu@${aws_instance.ec2-instance["instance1"].private_ip} << EOF",
#      "ping -q -c 1  ${aws_instance.ec2-instance["instance2"].private_ip} 2>&1 > /dev/null && echo SUCCESS || echo FAILED",
#      "EOF"
#    ]
#    connection {
#      type = "ssh"
#      user = "ubuntu"
#      private_key = tls_private_key.private_key.private_key_pem
#      host = aws_instance.bastion_host.public_ip
#      timeout = "10s"
#    }
#  }
#}

data "external" "external_ping_status" {
  program   = [
    "bash", "${path.module}/ping.sh"
  ]
  query = {
    number_of_instances=local.number_of_instances,
    bastion_ip=aws_eip.eip_bastion.public_ip,
    bastion_private_key=tls_private_key.private_key.private_key_pem,
    instances_ips=local.list_of_instances_ips
  }
}