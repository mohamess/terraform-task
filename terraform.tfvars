aws_region = "eu-central-1"
environment = "development"
application = "terraform-task"
vpc_name = "terraform-task-vpc"
vpc_cidr = "10.242.0.0/22"
public_subnet_cidrs = ["10.242.3.0/24"]
private_subnet_cidrs = ["10.242.2.0/24"]
subnets_availability_zones = ["eu-central-1a"]
ec2_instances = {
  instance0 = {
    instance_name           = "terraform-task-instance1"
    instance_type           = "t3.micro",
    instance_ami            = "ami-066866b740d9ce5a7"
  },
  instance1 = {
    instance_name           = "terraform-task-instance2"
    instance_type           = "t2.micro",
    instance_ami            = "ami-00648c36e527032ec"
  }
}
ec2_bastion = {
  instance_name           = "terraform-task-bastion"
  instance_type           = "t3.micro",
  instance_ami            = "ami-066866b740d9ce5a7"
}
root_password_length = 32