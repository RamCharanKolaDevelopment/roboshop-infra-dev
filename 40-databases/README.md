# 🗄️ 40-Databases

This layer is responsible for provisioning the stateful data storage systems required by the Roboshop application. It creates and bootstraps the backend database instances (MongoDB, Redis, MySQL, and RabbitMQ) inside the secure database subnets.

## 📋 Overview

The `40-databases` module performs the following key functions:
1. **Database Instances Provisioning**: Deploys four EC2 instances for the required databases using `t3.micro`.
2. **Secure Placement**: All databases are placed inside the private Database Subnets created in the `00-vpc` layer.
3. **Automated Bootstrapping**: Uses Terraform's `remote-exec` and `file` provisioners to copy and execute the `bootstrap.sh` script, which configures each database automatically on boot.
4. **IAM Configuration**: Creates and attaches an IAM instance profile specifically for MySQL to securely fetch credentials or parameters if needed.

## 🏗️ Architecture Visualization

The flowchart below visualizes the database provisioning flow, showing how SSM parameters (like Subnet IDs and Security Group IDs) are fetched, the instances are created, and the bootstrapping script is executed over SSH.

```mermaid
graph TD
    %% Inputs
    subgraph Inputs [Variables & Data Sources]
        AMI["local.ami_id"]
        DB_SUB["local.database_subnet_id"]
        SG["local.*_sg_id"]
    end

    %% Database Instances
    subgraph Instances [Database EC2 Instances]
        MONGO["MongoDB (t3.micro)"]
        REDIS["Redis (t3.micro)"]
        MYSQL["MySQL (t3.micro)"]
        RABBIT["RabbitMQ (t3.micro)"]
    end

    %% IAM Layer
    subgraph IAM_Layer [IAM Configuration]
        IAM_PROFILE["aws_iam_instance_profile.mysql"]
    end

    %% Provisioning
    subgraph Bootstrapping [Automated Configuration]
        BOOT["bootstrap.sh"]
        SSH["SSH Connection (remote-exec)"]
    end

    %% Connections
    AMI --> MONGO
    AMI --> REDIS
    AMI --> MYSQL
    AMI --> RABBIT

    DB_SUB --> MONGO
    DB_SUB --> REDIS
    DB_SUB --> MYSQL
    DB_SUB --> RABBIT

    SG --> MONGO
    SG --> REDIS
    SG --> MYSQL
    SG --> RABBIT

    IAM_PROFILE -->|"Attaches to"| MYSQL

    MONGO -->|"Triggers"| SSH
    REDIS -->|"Triggers"| SSH
    MYSQL -->|"Triggers"| SSH
    RABBIT -->|"Triggers"| SSH

    SSH -->|"Executes"| BOOT
```

## 🔐 Security and Access
- **Zero Public Access**: Databases do not have public IPs and reside in private subnets.
- **Strict Security Groups**: They are associated with strict security groups created in the `10-sg` layer, with ingress rules managed in `20-sg-rules`.
- **Bootstrapping**: The initialization is done via an SSH connection using the default `ec2-user` and password, transferring the `bootstrap.sh` script dynamically.

## 🚀 Execution

To provision the databases:
```bash
cd 40-databases
terraform init
terraform apply -auto-approve
```
