module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name                             = var.vpc_name
  cidr                             = var.vpc_cidr
  azs                              = var.subnets_availability_zones
  public_subnets                   = var.public_subnet_cidrs
  private_subnets                  = var.private_subnet_cidrs
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    application = var.application
    environment = var.environment
  }
}

resource "aws_eip" "eip_bastion" {
  instance = aws_instance.bastion_host.id
  vpc      = true

  tags = {
    Name = "eip-bastion"
    application = var.application
    environment = var.environment
  }
}

// SG to only allow PING & SSH
resource "aws_security_group" "allow_ssh_ping" {
  name        = "terraform-task-allow_ssh_ping"
  description = "Allow PING & SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "allow ping"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = var.private_subnet_cidrs
  }

  # Created an inbound rule for SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22

    # Here adding tcp instead of ssh, because ssh in part of tcp only!
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, "${aws_eip.eip_bastion.public_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-task-allow_ssh_ping"
    application = var.application
    environment = var.environment
  }
}

// SG to only allow PING & SSH
resource "aws_security_group" "allow_ssh_bastion" {
  name        = "terraform-task-allow_ssh_bastion"
  description = "Allow SSH inbound traffic to the bastion host"
  vpc_id      = module.vpc.vpc_id

  # Created an inbound rule for SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22

    # Here adding tcp instead of ssh, because ssh in part of tcp only!
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-task-allow_ssh_bastion"
    application = var.application
    environment = var.environment
  }
}