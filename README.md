### Prerequisites
- terraform version 1.3.5
- AWS account 

### Installation steps
- first install terraform to create the s3 bucket
```shell
cd s3-state-storage
terraform init
terraform plan
terraform apply
```
- install the ec2 instances
```shell
terraform init
terraform plan
terraform apply
```

### variables format
all variables are declared with types and the most important variables are declared in `terraform.tfvars`

### Deliverables
- 2 EC2 instances can be increased to any number by adding a new map key in `ec2_instances` variable
- EC2 instances are create in a private subnet in a vpc, ping only allowed and ssh from the bastion host
- EC2 bastion host created in the public subnet and have a public IP, used to ssh to the EC2 instances
- Setting the root password by using the EC2 instances userdata
- Ping from instance1 to instance2 and vice-versa but done in manual way (not the way requested in the task)
- The way i would think it should work is to create a separate script (e.g. [ping.sh](./ping.sh))
and in terraform use [external_data_source](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/data_source)
to have the ping status sent as terraform output (I didn't achieve this unfortunately)