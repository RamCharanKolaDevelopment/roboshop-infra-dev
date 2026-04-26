#!/bin/bash

# We are creating 50GB root disk, but only 20GB is partitioned
# Remaining 30GB we need to extend using below commands
growpart /dev/nvme0n1 4
lvextend -r -L +30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

# installing Terraform
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

# creating databases
cd /home/ec2-user
git clone https://github.com/RamCharanKolaDevelopment/roboshop-infra-dev.git
# chown ec2-user:ec2-user -R roboshop-infra-dev # if running this script while practicing manual deployment then should run like this "sudo chown ec2-user:ec2-user -R roboshop-infra-dev"
# cd roboshop-infra-dev/40-databases
# terraform init
# terraform apply -auto-approve

# creating components
# cd /home/ec2-user
# git clone https://github.com/RamCharanKolaDevelopment/roboshop-infra-dev.git
# chown ec2-user:ec2-user -R roboshop-infra-dev
# cd roboshop-infra-dev/90-components
# terraform init
# terraform apply -auto-approve